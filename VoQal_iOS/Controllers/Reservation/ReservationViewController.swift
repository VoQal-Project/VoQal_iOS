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
        selectedRoom = nil
        setIsHiddenTimeSection(true)
    }
    
    override func setAddTarget() {
        reservationView.reservationCustomView.fetchButton.addTarget(self, action: #selector(didTapFetchButton), for: .touchUpInside)
        reservationView.calendar.addTarget(self, action: #selector(didChangedDate(_:)), for: .valueChanged)
    }
    
    private func setCollectionView() {
        reservationView.reservationCustomView.roomCollectionButton.delegate = self
        reservationView.reservationCustomView.roomCollectionButton.dataSource = self
        reservationView.reservationCustomView.timeCollectionButton.delegate = self
        reservationView.reservationCustomView.timeCollectionButton.dataSource = self
    }
    
    private func convertSelectedDate(_ date: Date, _ toSubmit: Bool) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = toSubmit ? "yyyy-MM-dd": "yy년 M월 d일"
        return formatter.string(from: date)
    }
    
    private func convertToISO8601String(date: Date, time: String) -> String? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        // 년월일
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        // 시분
        let timeComponents = time.split(separator: ":").compactMap { Int($0) }
        let hour = timeComponents[0]
        let minute = timeComponents[1]
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // DateComponents로 Date 객체 생성
        guard let fullDate = calendar.date(from: dateComponents) else { return nil }
        
        // Date 객체를 ISO8601 형식의 문자열로 변환
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.string(from: fullDate)
    }
    
    private func timeRangeString(from startTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // 시작 시간을 Date 객체로 변환
        guard let startDate = dateFormatter.date(from: startTime) else {
            return nil
        }
        
        // Calendar를 사용하여 1시간 뒤의 시간을 계산
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else {
            return nil
        }
        
        // 시작 시간과 끝 시간을 문자열로 변환
        let startTimeString = dateFormatter.string(from: startDate)
        let endTimeString = dateFormatter.string(from: endDate)
        let timeRange = "\(startTimeString)~\(endTimeString)"
        
        return timeRange
    }
    
    private func convertEndTimeString(from startTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // 시작 시간을 Date 객체로 변환
        guard let startDate = dateFormatter.date(from: startTime) else {
            return nil
        }
        
        // Calendar를 사용하여 1시간 뒤의 시간을 계산
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        guard let endDate = calendar.date(byAdding: .hour, value: 1, to: startDate) else {
            return nil
        }
        
        return dateFormatter.string(from: endDate)
    }
    
    private func setIsHiddenTimeSection(_ isHidden: Bool) {
        self.reservationView.reservationCustomView.timeCustomLabel.isHidden = isHidden ? true : false
        self.reservationView.reservationCustomView.timeCollectionButton.isHidden = isHidden ? true : false
    }
    
    @objc private func didTapFetchButton() {
        print("사용 가능한 시간을 조회합니다")
        let convertedDate = convertSelectedDate(reservationView.calendar.date, true)
        if let selectedRoom = selectedRoom {
            reservationManager.fetchTimes(selectedRoom, convertedDate) { model in
                if let model = model {
                    print(model.convertedAvailableTimes)
                    self.availableTimes = model.convertedAvailableTimes
                    DispatchQueue.main.async {
                        self.setIsHiddenTimeSection(false)
                        self.reservationView.reservationCustomView.timeCollectionButton.reloadData()
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
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            if collectionView == reservationView.reservationCustomView.roomCollectionButton {
                selectedRoom = indexPath.item + 1
                setIsHiddenTimeSection(true)
                cell.configureSelectedCell(true)
                print(selectedRoom)
            }
            else if collectionView == reservationView.reservationCustomView.timeCollectionButton {
                cell.highlightSelectedCell()
                let message: String = "\n예약 날짜: \(convertSelectedDate(reservationView.calendar.date, false))\n예약 시간: \(timeRangeString(from: cell.contentLabel.text!)!)\n방 번호: \(selectedRoom!)\n\n선택하신 정보로 예약을 진행할까요?"
                let alert = UIAlertController(title: "예약 정보를 확인해주세요!", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    if let selectedRoom = self.selectedRoom,
                       let startTime = self.convertToISO8601String(date: self.reservationView.calendar.date, time: cell.contentLabel.text!),
                       let endTime = self.convertToISO8601String(date: self.reservationView.calendar.date, time: self.convertEndTimeString(from: cell.contentLabel.text!)!)
                    {
                        self.reservationManager.makeReservation(selectedRoom, startTime, endTime) { model in
                            guard let model = model else {
                                let alert = UIAlertController(title: "예약 실패", message: "예약 신청에 실패하였습니다.\n다시 시도해주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                                return
                            }
                            
                            if model.status == 200 {
                                let alert = UIAlertController(title: "예약 성공", message: "예약 신청이 완료되었습니다.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                    self.setIsHiddenTimeSection(true)
                                }))
                                self.present(alert, animated: true)
                            }
                            else {
                                let alert = UIAlertController(title: "예약 실패", message: "예약 가능한 시간이 아닙니다.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                    collectionView.reloadData()
                                }))
                                self.present(alert, animated: true)
                            }
                            
                        }
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                
                present(alert, animated: true)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == reservationView.reservationCustomView.roomCollectionButton {
            let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
            cell?.configureSelectedCell(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == reservationView.reservationCustomView.timeCollectionButton {
            return availableTimes.contains(allTimes[indexPath.item]) ? true : false
        }
        else if collectionView == reservationView.reservationCustomView.roomCollectionButton {
            return true
        }
        return true
    }
}

