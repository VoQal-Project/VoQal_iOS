//
//  EditReservationViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/22/24.
//

import UIKit

class EditReservationViewController: BaseViewController {
    
    internal var editCompletion: (()->Void)?
    
    private let editReservationView = EditReservationView()
    
    private let reservationManager = ReservationManager()
    private let myReservationManager = MyReservationManager()
    private var selectedRoom: Int? = nil
    
    private let allTimes = ["10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00"]
    private var availableTimes: [String] = []
    internal var reservationId: Int?
    
    override func loadView() {
        view = editReservationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        editReservationView.reservationCustomView.roomCollectionButton.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        editReservationView.reservationCustomView.timeCollectionButton.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        editReservationView.reservationCustomView.roomCollectionButton.delegate = self
        editReservationView.reservationCustomView.roomCollectionButton.dataSource = self
        editReservationView.reservationCustomView.timeCollectionButton.delegate = self
        editReservationView.reservationCustomView.timeCollectionButton.dataSource = self
    }
    
    override func setAddTarget() {
        editReservationView.reservationCustomView.fetchButton.addTarget(self, action: #selector(didTapFetchButton), for: .touchUpInside)
        editReservationView.calendar.addTarget(self, action: #selector(didChangedDate(_:)), for: .valueChanged)
    }
    
    private func setIsHiddenTimeSection(_ isHidden: Bool) {
        self.editReservationView.reservationCustomView.timeCustomLabel.isHidden = isHidden ? true : false
        self.editReservationView.reservationCustomView.timeCollectionButton.isHidden = isHidden ? true : false
    }
    
    @objc private func didTapFetchButton() {
        print("사용 가능한 시간을 조회합니다")
        let convertedDate = DateUtility.convertSelectedDate(editReservationView.calendar.date, true)
        if let selectedRoom = selectedRoom {
            reservationManager.fetchTimes(selectedRoom, convertedDate) { model in
                if let model = model {
                    print(model.convertedAvailableTimes)
                    self.availableTimes = model.convertedAvailableTimes
                    DispatchQueue.main.async {
                        self.editReservationView.reservationCustomView.timeCollectionButton.reloadData()
                        self.setIsHiddenTimeSection(false)
                    }
                }
            }
        }
    }
    
    @objc private func didChangedDate(_ sender: UIDatePicker) {
        print("date changed!")
        self.setIsHiddenTimeSection(true)
    }

}

extension EditReservationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        
        if collectionView == editReservationView.reservationCustomView.roomCollectionButton {
            itemCount = 5
        }
        else if collectionView == editReservationView.reservationCustomView.timeCollectionButton {
            itemCount = allTimes.count
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            print("EditReservationViewController - CustomCollectionViewCell 불러오기 실패")
            
            return UICollectionViewCell()
        }
        
        let isLast = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
        
        if collectionView == editReservationView.reservationCustomView.roomCollectionButton {
            cell.configure("\(indexPath.item + 1)번 방", isLast)
        }
        else if collectionView == editReservationView.reservationCustomView.timeCollectionButton {
            cell.configure("\(allTimes[indexPath.item])", isLast)
            if !availableTimes.contains(allTimes[indexPath.item]) {
                cell.configureAvailableTime(false)
            } else {
                cell.configureAvailableTime(true)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize()
        
        if collectionView == editReservationView.reservationCustomView.roomCollectionButton {
            size = CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        }
        else if collectionView == editReservationView.reservationCustomView.timeCollectionButton {
            size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            if collectionView == editReservationView.reservationCustomView.roomCollectionButton {
                selectedRoom = indexPath.item + 1
                if let selectedRoom = self.selectedRoom {
                    print("selectedRoom : \(self.selectedRoom)")
                }
                else {
                    print("selectedRoom 설정 실패")
                }
                setIsHiddenTimeSection(true)
                cell.configureSelectedCell(true)
            }
            else if collectionView == editReservationView.reservationCustomView.timeCollectionButton {
                cell.highlightSelectedCell()
                let message: String = "\n예약 날짜: \(DateUtility.convertSelectedDate(editReservationView.calendar.date, false))\n예약 시간: \(DateUtility.timeRangeString(from: cell.contentLabel.text!)!)\n방 번호: \(self.selectedRoom!)\n\n선택하신 정보로 예약을 수정할까요?"
                let alert = UIAlertController(title: "예약 정보를 확인해주세요!", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    if let selectedRoom = self.selectedRoom,
                       let startTime = DateUtility.convertToISO8601String(date: self.editReservationView.calendar.date, time: cell.contentLabel.text!),
                       let endTime = DateUtility.convertToISO8601String(date: self.editReservationView.calendar.date, time: DateUtility.convertEndTimeString(from: cell.contentLabel.text!)!),
                       let reservationId = self.reservationId
                    {
                        print("editMyReservation에 대한 값들로 넘깁니다. selectedRoom: \(self.selectedRoom), startTime: \(startTime), endTime: \(endTime), reservationId: \(reservationId)")
                        self.myReservationManager.editMyReservation(selectedRoom, startTime, endTime, reservationId) { model in
                            guard let model = model else {
                                let alert = UIAlertController(title: "예약 실패", message: "예약 수정에 실패하였습니다.\n다시 시도해주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                                return
                            }
                            
                            if model.status == 200 {
                                let alert = UIAlertController(title: "예약 성공", message: "예약 수정이 완료되었습니다.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                    self.dismiss(animated: true) {
                                        self.editCompletion?()
                                    }
                                }))
                                self.present(alert, animated: true)
                            }
                            else {
                                let alert = UIAlertController(title: "예약 실패", message: "예약 가능한 시간이 아닙니다. 원하는 날짜와 연습실을 선택하여 다시 조회 후 가능한 시간으로 수정해주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                    self.setIsHiddenTimeSection(true)
                                }))
                                self.present(alert, animated: true)
                            }
                            
                        }
                    }
                    else {
                        print("예약 수정 전 옵셔널 바인딩 실패")
                    }
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                
                present(alert, animated: true)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == editReservationView.reservationCustomView.roomCollectionButton {
            let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
            cell?.configureSelectedCell(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == editReservationView.reservationCustomView.timeCollectionButton {
            return availableTimes.contains(allTimes[indexPath.item]) ? true : false
        }
        else if collectionView == editReservationView.reservationCustomView.roomCollectionButton {
            return true
        }
        return true
    }
    
}
