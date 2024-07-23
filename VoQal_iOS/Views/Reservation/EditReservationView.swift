//
//  EditReservationView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/22/24.
//

import UIKit

class EditReservationView: BaseView {
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "1F1F1F")
        
        return view
    }()
    
    internal let calendar: UIDatePicker = {
        let calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .wheels
        calendar.locale = Locale(identifier: "ko-KR")
        
        var components = DateComponents()
        components.day = 14
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        components.day = 0
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        calendar.maximumDate = maxDate
        calendar.minimumDate = minDate
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        return calendar
    }()
    
    internal let reservationCustomView = ReservationCustomView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexCode: "1F1F1F")
        reservationCustomView.backgroundColor = UIColor(hexCode: "1F1F1F")
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        addSubview(contentView)
        contentView.addSubview(calendar)
        contentView.addSubview(reservationCustomView)
    }
    
    override func setConstraints() {
        
        reservationCustomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            calendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            reservationCustomView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 5),
            reservationCustomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            reservationCustomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            reservationCustomView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
        ])
        
    }

}
