//
//  ReservationView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class ReservationView: BaseView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "mainBackgrounColor")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    internal let calendar: UIDatePicker = {
        let calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.preferredDatePickerStyle = .inline
        calendar.locale = Locale(identifier: "ko-KR")
        
        var components = DateComponents()
        components.day = 14
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        components.day = 0
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        calendar.maximumDate = maxDate
        calendar.minimumDate = minDate
        
        return calendar
    }()
    
    internal let reservationCustomView = ReservationCustomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(calendar)
        contentView.addSubview(reservationCustomView)
    }
    
    override func setConstraints() {
        
        reservationCustomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            calendar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            calendar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            calendar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            reservationCustomView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            reservationCustomView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            reservationCustomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            reservationCustomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            reservationCustomView.heightAnchor.constraint(equalToConstant: 300),
            
            contentView.bottomAnchor.constraint(equalTo: reservationCustomView.bottomAnchor, constant: 30)
            
        ])
    }
}

