//
//  MyChallengePostViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit

class MyChallengePostViewController: BaseViewController {

    private let myChallengePostView = MyChallengePostView()
    private let myChallengePostManager = MyChallengePostManager()
    private var isFetching: Bool = false
    private var lastFetchTime: Date?
    private var myPosts: [MyChallengePost] = []
    
    override func loadView() {
        view = myChallengePostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myChallengePostManager.fetchMyChallengePosts { model in
            guard let model = model else { print("myChallengePostView - model 바인딩 실패"); return }
            
            if model.status == 200 {
                guard let data = model.data else { print("myChallengePostView - data 바인딩 실패"); return }
                
                self.myPosts = data
                self.myChallengePostView.collectionView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        
    }
    
    private func fetchMoreData() {
        isFetching = true
        lastFetchTime = Date()
        
        Task {
            print("fetchMoreData!")
            self.isFetching = false
        }
    }
   
}

extension MyChallengePostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier, for: indexPath) as? ChallengeCollectionViewCell else {
            print("challengeViewController - dequeueReusableCell 실패")
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            if !isFetching {
                fetchMoreData()
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
