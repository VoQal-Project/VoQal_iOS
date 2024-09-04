//
//  MyChallengePostViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit
import AVFoundation

class MyChallengePostViewController: BaseViewController {
    
    private let myChallengePostView = MyChallengePostView()
    private let myChallengePostManager = MyChallengePostManager()
    
    private var myPosts: [MyChallengePost] = []
    
    override func loadView() {
        view = myChallengePostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myChallengePostView.collectionView.dataSource = self
        myChallengePostView.collectionView.delegate = self
        myChallengePostView.collectionView.register(MyChallengePostCollectionViewCell.self, forCellWithReuseIdentifier: MyChallengePostCollectionViewCell.identifier)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        playPlayer()
        setIsHiddenCoverImageView(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        temporarilyStopPlayer()
    }
    
    private func fetchData() {
        myChallengePostManager.fetchMyChallengePosts { model in
            guard let model = model else { print("myChallengePostView - model 바인딩 실패"); return }
            
            if model.status == 200 {
                guard let data = model.data else { print("myChallengePostView - data 바인딩 실패"); return }
                
                self.myPosts = data
                self.myChallengePostView.collectionView.reloadData()
            }
        }
    }
    
    private func didTapEditButton() {
        print("수정 탭!")
        
        
    }
    
    private func didTapDeleteButton(challengePostId: Int64) {
        print("삭제 탭!")
        
        let alert = UIAlertController(title: "게시물을 삭제하시겠어요?", message: "게시물이 영구적으로 삭제됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            self.myChallengePostManager.deleteChallengePost(challengePostId) { model in
                guard let model = model else { print("deleteChallengePost - model 바인딩 실패!"); return }
                if model.status == 200 {
                    self.fetchData()
                }
                else {
                    print("didTapDeleteButton failed!")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: false)
    }
    
    private func stopAllPlayers() {
        for cell in myChallengePostView.collectionView.visibleCells {
            if let challengeCell = cell as? MyChallengePostCollectionViewCell {
                challengeCell.player?.pause()
                challengeCell.player = nil
            }
        }
    }
    
    private func temporarilyStopPlayer() {
        for cell in myChallengePostView.collectionView.visibleCells {
            if let challengeCell = cell as? MyChallengePostCollectionViewCell {
                challengeCell.player?.pause()
            }
        }
    }
    
    private func playPlayer() {
        for cell in myChallengePostView.collectionView.visibleCells {
            if let challengeCell = cell as? MyChallengePostCollectionViewCell {
                challengeCell.player?.play()
            }
        }
    }
    
    private func setIsHiddenCoverImageView(_ isHidden: Bool) {
        for cell in myChallengePostView.collectionView.visibleCells {
            if let challengeCell = cell as? MyChallengePostCollectionViewCell {
                challengeCell.coverImageView.isHidden = isHidden
            }
        }
    }
    
}

extension MyChallengePostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChallengePostCollectionViewCell.identifier, for: indexPath) as? MyChallengePostCollectionViewCell else {
            print("MyChallengeCollectionViewCell dequeue실패.")
            return UICollectionViewCell()
        }
        
        let post = myPosts[indexPath.row]
        let likeCount = post.likeCount
        let songTitle = post.songTitle
        let singer = post.singer
        let nickname = post.nickName
        
        cell.configure(likeCount, songTitle, singer, nickname)
        
        let firstAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { _ in
            print("수정 탭")
        }
        let secondAction = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { _ in
            print("삭제 탭")
            self.didTapDeleteButton(challengePostId: Int64(post.challengePostId))
        }
        cell.setMenuButton(firstAction, secondAction)
        
        myChallengePostManager.downloadThumbnailImage("\(PrivateUrl.shared.getS3UrlHead())\(post.thumbnailUrl)") { [weak cell, indexPath] image in
            guard let cell = cell, collectionView.indexPath(for: cell) == indexPath else {
                return
            }
            DispatchQueue.main.async {
                cell.updateThumbnail(image)
            }
        }
        
        // 음원 플레이어 설정
        if let url = URL(string: "\(PrivateUrl.shared.getS3UrlHead())\(post.recordUrl)") {
            let player = AVPlayer(url: url)
            cell.updatePlayer(player)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MyChallengePostCollectionViewCell {
            cell.togglePlayPause()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MyChallengePostCollectionViewCell {
            cell.togglePlayPause() // 셀이 사라지면 자동으로 일시정지
        }
    }
}



extension MyChallengePostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}

extension MyChallengePostViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController != self {
            stopAllPlayers()
        }
        return true
    }
}
