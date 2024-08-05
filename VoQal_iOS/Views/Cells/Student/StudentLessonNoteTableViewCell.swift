//
//  StudentLessonNoteTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/5/24.
//

import UIKit

class StudentLessonNoteTableViewCell: UITableViewCell {

    static let identifier = "StudentLessonNoteTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StudentLessonNoteTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        
    }
    
    private func setConstraints() {
        
    }
    
}
