//
//  ChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class ChallengeViewController: BaseViewController {

    private let challengeView = ChallengeView()
    
    private var challengePosts: [Any] = [] // 챌린지 게시글 조회 api 안정화 후 설정
    private var lastFetchTime: Date?
    private var page: Int32 = 0
    var isFetching = false
    
    override func loadView() {
        view = challengeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        challengeView.challengeViewController = self
        challengeView.collectionView.delegate = self
        challengeView.collectionView.dataSource = self
        challengeView.collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
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
    
    func didTapPostChallengeBtn() {
        let vc = PostChallengeViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true) {
            
        }
    }
    
    func didTapMyLikePostBtn() {
        let vc = MyLikePostChallengeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapMyPostBtn() {
        let vc = MyChallengePostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ChallengeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ChallengeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
