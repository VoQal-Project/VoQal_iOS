//
//  StudentLessonManageView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/31/24.
//

import UIKit

class StudentLessonManageView: BaseView {
    
    let lessonTabViewController = LessonTabViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    
    override func addSubViews() {
        addSubview(lessonTabViewController.view)
    }
    
    override func setConstraints() {
        
        guard let lessonTabView = self.lessonTabViewController.view else { print("StudentLessonManageView - lessonTabView 바인딩 실패"); return }
        lessonTabView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lessonTabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lessonTabView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lessonTabView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            lessonTabView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    
}



