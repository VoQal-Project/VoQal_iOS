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
    
    private func didTapEditButton(_ singer: String, _ songTitle: String, _ thumbnail: UIImage, _ challengePostId: Int64) {
        print("수정 탭!")
        
        let vc = EditChallengeViewController()
        vc.setValues(singer, songTitle, thumbnail, challengePostId)
        vc.editCompletion = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.fetchData()
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true)
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
        var thumbnail: UIImage?
        let challengePostId = post.challengePostId
        
        cell.configure(likeCount, songTitle, singer, nickname)
        
        myChallengePostManager.downloadThumbnailImage("\(PrivateUrl.shared.getS3UrlHead())\(post.thumbnailUrl)") { [weak cell, indexPath] image in
            guard let cell = cell, collectionView.indexPath(for: cell) == indexPath else {
                return
            }
            DispatchQueue.main.async {
                cell.updateThumbnail(image)
                thumbnail = image
            }
        }
        
        // 음원 플레이어 설정
        if let url = URL(string: "\(PrivateUrl.shared.getS3UrlHead())\(post.recordUrl)") {
            let player = AVPlayer(url: url)
            cell.updatePlayer(player)
        }
        
        let firstAction = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
            print("수정 탭")
            guard let self = self, let thumbnail = thumbnail else { return }
            self.didTapEditButton(singer, songTitle, thumbnail, Int64(challengePostId))
            
        }
        let secondAction = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { [weak self] _ in
            print("삭제 탭")
            guard let self = self else { return }
            self.didTapDeleteButton(challengePostId: Int64(challengePostId))
        }
        cell.setMenuButton(firstAction, secondAction)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MyChallengePostCollectionViewCell {
            cell.togglePlayPause()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MyChallengePostCollectionViewCell {
            if let player = cell.player {
                cell.player?.pause()
            }
            else {
                print("player is nil")
            }
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
