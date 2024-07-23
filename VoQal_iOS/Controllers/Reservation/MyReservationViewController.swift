//
//  ReservationManageViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/21/24.
//

import UIKit

class MyReservationViewController: BaseViewController, MyReservationTableViewCellDelegate {

    private let myReservationView = MyReservationView()
    private let myReservationManager = MyReservationManager()
    var reservations: [Reservation] = []
    
    override func loadView() {
        view = myReservationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myReservationView.tableView.register(MyReservationTableViewCell.self, forCellReuseIdentifier: MyReservationTableViewCell.identifier)
        myReservationView.tableView.delegate = self
        myReservationView.tableView.dataSource = self
        
        fetchMyReservations()
    }
    
    private func fetchMyReservations() {
        myReservationManager.getMyReservations { model in
            guard let model = model else {
                print("model을 받아오는 데에 실패했습니다.")
                return
            }
            if model.status == 200 {
                print("내 예약을 받아오는 데에 성공했습니다.")
                self.reservations = model.sortedData.compactMap { data in
                    
                    return Reservation(roomId: data.roomId, reservationId: data.reservationId, startTime: data.startTime, endTime: data.endTime)
                    
                }
                
                DispatchQueue.main.async {
                    self.myReservationView.tableView.reloadData()
                }
            }
            else {
                print("내 예약을 받아오는 데에 실패했습니다.")
            }
        }
    }
    
    func didTapEditButton(_ cell: MyReservationTableViewCell) {
        print("예약 수정 버튼 탭!")
        showSheet(cell)
    }
    
    func didTapDeleteButton(_ cell: MyReservationTableViewCell) {
        guard let indexPath = myReservationView.tableView.indexPath(for: cell) else { return }
        
        let reservation = reservations[indexPath.row]
        guard let reservedDate = DateUtility.convertToDateString(reservation.startTime),
              let reservedTime = DateUtility.iSO8601timeRangeString(from: reservation.startTime)
        else { return }
        let message = "\(reservedDate) \(reservedTime)에 예약된 연습실 \(reservation.roomId)번 방 예약을 취소할까요?"
        
        let alert = UIAlertController(title: "예약을 취소할까요?", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            self.myReservationManager.deleteMyReservation(self.reservations[indexPath.row].reservationId) { model in
                guard let model = model else {return}
                
                if model.status == 200 {
                    let alert = UIAlertController(title: "취소 완료!", message: "해당 연습실 예약을 취소했습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.fetchMyReservations()
                    }))
                    self.present(alert, animated: true)
                }
                else {
                    let alert = UIAlertController(title: "취소 실패", message: "해당 연습실 예약을 취소하지 못했습니다.\n잠시 후 다시 시도해 주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showSheet(_ cell: MyReservationTableViewCell) {
        guard let indexPath = myReservationView.tableView.indexPath(for: cell) else { return }
        
        let viewControllerToPresent = EditReservationViewController()
        viewControllerToPresent.reservationId = reservations[indexPath.row].reservationId
        viewControllerToPresent.modalPresentationStyle = .pageSheet
        viewControllerToPresent.editCompletion = { () in
            print("예약 변경 완료")
            self.fetchMyReservations()
        }
        
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            return 500
        }

        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [customDetent]
            sheet.largestUndimmedDetentIdentifier = detentIdentifier  // nil 기본값
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = false // false 기본값
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // false 기본값
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 12.0
        }

        present(viewControllerToPresent, animated: true, completion: nil)
    }
    
}

extension MyReservationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyReservationTableViewCell.identifier, for: indexPath) as? MyReservationTableViewCell else {
            print("셀을 정의하는 데에 실패했습니다.")
            return UITableViewCell()
        }
        let reservation = reservations[indexPath.row]
        print("reservation: \(reservation)")
        let date = DateUtility.convertStringToDate(reservation.startTime)
        let roomId = reservation.roomId
        guard let time = DateUtility.iSO8601timeRangeString(from: reservation.startTime) else {
            print("TimeRangeString failed")
            return UITableViewCell()
        }
        
        cell.configure(date, roomId, time)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}
