//
//  MyLikePostChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit
import AVFoundation

class MyLikePostChallengeViewController: BaseViewController {

    private let myLikePostChallengeView = MyLikePostChallengeView()
    private let myLikeChallengePostManager = MyLikeChallengePostManager()
    private let challengeManager = ChallengeManager()
    private var myLikePosts: [MyLikePost] = []
    
    override func loadView() {
        view = myLikePostChallengeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLikePostChallengeView.collectionView.register(MyLikePostCollectionViewCell.self, forCellWithReuseIdentifier: MyLikePostCollectionViewCell.identifier)
        myLikePostChallengeView.collectionView.dataSource = self
        myLikePostChallengeView.collectionView.delegate = self
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
        
        myLikeChallengePostManager.fetchMyLikePost { [weak self] model in
            guard let self = self, let model = model else { print("myLikeChallengePostManager - fetchMyLikePost model is nil"); return }
            
            if model.status == 200 {
                self.myLikePosts = model.data
                DispatchQueue.main.async {
                    self.myLikePostChallengeView.collectionView.reloadData()
                }
            }
            else {
                print("fetchMyLikePost - status is not 200")
            }
        }
        
    }
    
    @objc private func didTapLikeButton(_ sender: UIButton) {
        let post = myLikePosts[sender.tag]
        let postId = Int64(post.challengeId)
        
        guard let cell = sender.superview?.superview as? MyLikePostCollectionViewCell else {
            print("셀을 찾을 수 없습니다.")
            return
        }
        
        let liked = cell.liked
        
        if liked == false {
            challengeManager.likeChallengePost(postId) { model in
                guard let model = model else { print("MyLikePostChallengeViewController - likeChallengePost model 바인딩 실패"); return }
                if model.status == 200 {
                    // 좋아요 성공 처리
                    DispatchQueue.main.async {
                        cell.updateLikeBtn(true)
                        cell.liked = true
                    }
                }
                else {
                    print("model.status가 200이 아님 (didTapLikeButton)")
                }
            }
        } else {
            challengeManager.unlikeChallengePost(postId) { model in
                guard let model = model else { print("MyLikePostChallengeViewController - unlikeChallengePost model 바인딩 실패"); return }
                if model.status == 200 {
                    // 좋아요 취소 성공 처리
                    DispatchQueue.main.async {
                        cell.updateLikeBtn(false)
                        cell.liked = false
                    }
                }
                else {
                    print("model.status가 200이 아님 (didTapLikeButton)")
                }
            }
        }
    }
    
    private func stopAllPlayers() {
        for cell in myLikePostChallengeView.collectionView.visibleCells {
            if let challengeCell = cell as? MyLikePostCollectionViewCell {
                challengeCell.player?.pause()
                challengeCell.player = nil
            }
        }
    }
    
    private func temporarilyStopPlayer() {
        for cell in myLikePostChallengeView.collectionView.visibleCells {
            if let challengeCell = cell as? MyLikePostCollectionViewCell {
                challengeCell.player?.pause()
            }
        }
    }
    
    private func playPlayer() {
        for cell in myLikePostChallengeView.collectionView.visibleCells {
            if let challengeCell = cell as? MyLikePostCollectionViewCell {
                challengeCell.player?.play()
            }
        }
    }
    
    private func playCurrentCell(at indexPath: IndexPath) {
        guard let cell = myLikePostChallengeView.collectionView.cellForItem(at: indexPath) as? MyLikePostCollectionViewCell else {
            print("playCurrentCell - cell 바인딩 실패")
            return
        }
        
        if let player = cell.player {
            player.play()
        }
        else {
            print("player 바인딩 실패");
        }
    }
    
    private func setIsHiddenCoverImageView(_ isHidden: Bool) {
        for cell in myLikePostChallengeView.collectionView.visibleCells {
            if let challengeCell = cell as? MyLikePostCollectionViewCell {
                challengeCell.coverImageView.isHidden = isHidden
            }
        }
    }

}

extension MyLikePostChallengeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myLikePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyLikePostCollectionViewCell.identifier, for: indexPath) as? MyLikePostCollectionViewCell else {
            print("ChallengeCollectionViewCell dequeue실패.")
            return UICollectionViewCell()
        }
        
        let post = myLikePosts[indexPath.row]
        let songTitle = post.songTitle
        let singer = post.singer
        let nickname = post.nickName
        
        cell.configure(songTitle, singer, nickname)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        
        challengeManager.downloadThumbnailImage("\(PrivateUrl.shared.getS3UrlHead())\(post.thumbnailUrl)") { [weak cell, indexPath] image in
            guard let cell = cell, collectionView.indexPath(for: cell) == indexPath else {
                return
            }
            DispatchQueue.main.async {
                cell.updateThumbnail(image)
            }
        }
        
        // 음원 플레이어 설정
        if let url = URL(string: "\(PrivateUrl.shared.getS3UrlHead())\(post.challengeRecordUrl)") {
            let player = AVPlayer(url: url)
            cell.updatePlayer(player)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MyLikePostCollectionViewCell {
            cell.togglePlayPause()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MyLikePostCollectionViewCell {
            cell.togglePlayPause() // 셀이 사라지면 자동으로 일시정지
        }
    }
}



extension MyLikePostChallengeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}

extension MyLikePostChallengeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController != self {
            stopAllPlayers()
        }
        return true
    }
}
