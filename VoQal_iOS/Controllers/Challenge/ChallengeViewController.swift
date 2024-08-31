//
//  ChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit
import AVFoundation

class ChallengeViewController: BaseViewController {
    
    private let challengeView = ChallengeView()
    private let challengeManager = ChallengeManager()
    private var challengePosts: [ChallengePost] = [] // 챌린지 게시글 조회 api 안정화 후 설정
    private var page: Int32 = 0
    var isFetching = false
    
    private var currentVisibleIndex: IndexPath?
    
    override func loadView() {
        view = challengeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarController?.delegate = self
        challengeView.challengeViewController = self
        challengeView.collectionView.delegate = self
        challengeView.collectionView.dataSource = self
        challengeView.collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        
        fetchData(){}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playPlayer()
        setIsHiddenCoverImageView(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        temporarilyStopPlayer()
    }
    
    private func fetchData(completion: () -> Void) {
        challengeManager.fetchChallengePosts(page: page, size: 20) { model in
            guard let model = model else { print("challengeViewController - model 바인딩 실패"); return }
            
            if model.status == 200 {
                if let data = model.data {
                    if self.page == 0 {
                        self.challengePosts = data
                    }
                    else {
                        self.challengePosts.append(contentsOf: data)
                    }
                    DispatchQueue.main.async {
                        self.challengeView.collectionView.reloadData()
                    }
                }
                else {
                    print("챌린지 게시글을 받아오는 데에 실패했습니다.")
                }
            }
        }
    }
    
    private func fetchMoreData() {
        isFetching = true
        
        Task {
            print("fetchMoreData!")
            page += 1
            fetchData {
                self.isFetching = false
            }
        }
    }
    
    func didTapPostChallengeBtn() {
        let vc = PostChallengeViewController()
        vc.postCompletion = {
            self.fetchData {}
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func didTapMyLikePostBtn() {
        let vc = MyLikePostChallengeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapMyPostBtn() {
        let vc = MyChallengePostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLikeButton(_ sender: UIButton) {
        let post = challengePosts[sender.tag]
        let postId = Int64(post.challengeId)
        var liked = post.liked
        
        guard let cell = sender.superview?.superview as? ChallengeCollectionViewCell else {
            print("셀을 찾을 수 없습니다.")
            return
        }
        
        if liked == false {
            challengeManager.likeChallengePost(postId) { model in
                guard let model = model else { print("challengeViewController - likeChallengePost model 바인딩 실패"); return }
                if model.status == 200 {
                    // 좋아요 성공 처리
                    DispatchQueue.main.async {
                        cell.updateLikeBtn(true)
                        self.challengePosts[sender.tag].liked = true // 메모리 상에 liked를 임시로 true 설정
                    }
                }
                else {
                    print("model.status가 200이 아님 (didTapLikeButton)")
                }
            }
        } else {
            challengeManager.unlikeChallengePost(postId) { model in
                guard let model = model else { print("challengeViewController - unlikeChallengePost model 바인딩 실패"); return }
                if model.status == 200 {
                    // 좋아요 취소 성공 처리
                    DispatchQueue.main.async {
                        cell.updateLikeBtn(false)
                        self.challengePosts[sender.tag].liked = false
                        
                    }
                }
                else {
                    print("model.status가 200이 아님 (didTapLikeButton)")
                }
            }
        }
    }
    
    private func stopAllPlayers() {
        for cell in challengeView.collectionView.visibleCells {
            if let challengeCell = cell as? ChallengeCollectionViewCell {
                challengeCell.player?.pause()
                challengeCell.player = nil
            }
        }
    }
    
    private func temporarilyStopPlayer() {
        for cell in challengeView.collectionView.visibleCells {
            if let challengeCell = cell as? ChallengeCollectionViewCell {
                challengeCell.player?.pause()
            }
        }
    }
    
    private func playPlayer() {
        for cell in challengeView.collectionView.visibleCells {
            if let challengeCell = cell as? ChallengeCollectionViewCell {
                challengeCell.player?.play()
            }
        }
    }
    
    private func playCurrentCell(at indexPath: IndexPath) {
        guard let cell = challengeView.collectionView.cellForItem(at: indexPath) as? ChallengeCollectionViewCell else {
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
        for cell in challengeView.collectionView.visibleCells {
            if let challengeCell = cell as? ChallengeCollectionViewCell {
                challengeCell.coverImageView.isHidden = isHidden
            }
        }
    }
    
}


extension ChallengeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(challengePosts.count)
        return challengePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as? ChallengeCollectionViewCell else {
            print("challengeViewController - dequeueReusableCell 실패")
            return UICollectionViewCell()
        }
        
        let post = challengePosts[indexPath.row]
        let liked = post.liked
        let songTitle = post.songTitle
        let singer = post.singer
        let nickname = post.nickName
        
        cell.configure(liked, songTitle, singer, nickname)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
        
        // 썸네일 이미지 로드
        challengeManager.downloadThumbnailImage("\(PrivateUrl.shared.getS3UrlHead())\(post.thumbnailUrl)") { [weak cell, indexPath] image in
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths = challengeView.collectionView.indexPathsForVisibleItems
        if let currentVisibleIndex = visibleIndexPaths.first {
            if self.currentVisibleIndex == nil || self.currentVisibleIndex != currentVisibleIndex {
                
                print("scrollViewDidEndDecelerating!!")
                temporarilyStopPlayer()
                playCurrentCell(at: currentVisibleIndex)
                self.currentVisibleIndex = currentVisibleIndex
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row + 1) % 20 == 0, !isFetching {
            fetchMoreData()
        }
        if let cell = cell as? ChallengeCollectionViewCell {
            cell.togglePlayPause()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ChallengeCollectionViewCell {
            if let player = cell.player {
                cell.player?.pause()
            }
            else {
                print("player is nil")
            }
        }
    }
}

extension ChallengeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
