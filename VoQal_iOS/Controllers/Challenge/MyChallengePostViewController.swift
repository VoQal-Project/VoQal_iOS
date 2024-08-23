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
        
        fetchData()
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
