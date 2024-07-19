//
//  ReservationViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class ReservationViewController: BaseViewController {
    
    private let reservationView = ReservationView()
    private let reservationManager = ReservationManager()
    private var selectedRoom: Int? = nil
    
    private let allTimes = ["10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00"]
    private var availableTimes: [String] = []
    
    override func loadView() {
        view = reservationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        
        reservationView.reservationCustomView.roomCollectionButton.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        reservationView.reservationCustomView.timeCollectionButton.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reservationView.calendar.date = Date()
    }
    
    override func setAddTarget() {
        reservationView.reservationCustomView.fetchButton.addTarget(self, action: #selector(didTapFetchButton), for: .touchUpInside)
    }
    
    private func setCollectionView() {
        reservationView.reservationCustomView.roomCollectionButton.delegate = self
        reservationView.reservationCustomView.roomCollectionButton.dataSource = self
        reservationView.reservationCustomView.timeCollectionButton.delegate = self
        reservationView.reservationCustomView.timeCollectionButton.dataSource = self
    }
    
    @objc private func didTapFetchButton() {
        
        let date = reservationView.calendar.date
        if let selectedRoom = selectedRoom {
            reservationManager.fetchTimes(selectedRoom, date) { model in
                if let model = model {
                    print(model.convertedAvailableTimes)
                    self.availableTimes = model.convertedAvailableTimes
                    DispatchQueue.main.async {
                        self.reservationView.reservationCustomView.timeCustomLabel.isHidden = false
                        self.reservationView.reservationCustomView.timeCollectionButton.isHidden = false
                        self.reservationView.reservationCustomView.timeCollectionButton.reloadData()
                    }
                }
            }
        }
    }
    
}

extension ReservationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        
        if collectionView == reservationView.reservationCustomView.roomCollectionButton {
            itemCount = 5
        }
        else if collectionView == reservationView.reservationCustomView.timeCollectionButton {
            itemCount = allTimes.count
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let isLast = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
        
        if collectionView == reservationView.reservationCustomView.roomCollectionButton {
            cell.configure("\(indexPath.item + 1)번 방", isLast)
        }
        else if collectionView == reservationView.reservationCustomView.timeCollectionButton {
            cell.configure("\(allTimes[indexPath.item])", isLast)
            if !availableTimes.contains(allTimes[indexPath.item]) {
                print("사용 불가능합니다. \(allTimes[indexPath.item])")
                cell.configureAvailableTime(false)
            } else {
                cell.configureAvailableTime(true)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize()
        
        if collectionView == reservationView.reservationCustomView.roomCollectionButton {
            size = CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        }
        else if collectionView == reservationView.reservationCustomView.timeCollectionButton {
            size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRoom = indexPath.item
        
        print(selectedRoom!)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == reservationView.reservationCustomView.timeCollectionButton {
            return availableTimes.contains(allTimes[indexPath.item]) ? true : false
        }
        return true
    }
}

