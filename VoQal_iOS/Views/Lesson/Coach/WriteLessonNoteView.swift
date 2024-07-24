//
//  WriteLessonNoteView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/24/24.
//

import UIKit

class WriteLessonNoteView: BaseView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "111111", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate let lessonDateView: UIView = {
        let view = UIView()
        let title = UILabel()
        let datePicker = UIDatePicker()
        
        title.text = "레슨 일자"
        title.font = UIFont(name: "SUIT-Regular", size: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            title.topAnchor.constraint(equalTo: view.topAnchor),
            
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }()
    
    fileprivate let titleView: UIView = {
        let view = UIView()
        let title = UILabel()
        let textField = CustomTextField()
        
        title.text = "제목"
        title.font = UIFont(name: "SUIT-Regular", size: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "제목을 입력해주세요"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -3),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        return view
    }()
    
    fileprivate let lessonSongView: UIView = {
        let view = UIView()
        let title = UILabel()
        let artistTextField = CustomTextField()
        let titleTextField = CustomTextField()
        
        title.text = "레슨곡"
        title.font = UIFont(name: "SUIT-Regular", size: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        artistTextField.placeholder = "가수명"
        artistTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.placeholder = "곡명"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        view.addSubview(artistTextField)
        view.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor),
            
            artistTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -3),
            artistTextField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            artistTextField.heightAnchor.constraint(equalToConstant: 40),
            artistTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            
            titleTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: artistTextField.topAnchor),
            titleTextField.heightAnchor.constraint(equalTo: artistTextField.heightAnchor),
        ])
        
        return view
    }()

    internal let lessonContentView: UIView = {
        let view = UIView()
        let title = UILabel()
        let textView = UITextView()
        let textCountLabel = UILabel()
        
        title.text = "내용"
        title.font = UIFont(name: "SUIT-Regular", size: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        textView.textColor = .white
        textView.font = UIFont(name: "SUIT-Regular", size: 16)
        textView.text = "내용을 입력해주세요."
        textView.textColor = UIColor(named: "placeholderColor")
        textView.layer.cornerRadius = 5.0
        textView.layer.cornerCurve = .continuous
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor(named: "mainButtonColor")!.cgColor
        textView.backgroundColor = UIColor(hexCode: "111111")
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor),
            title.heightAnchor.constraint(equalToConstant: 22),
            title.widthAnchor.constraint(equalToConstant: 30),
            
            textView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -3),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        
        return view
    }()
    
    var contentViewTextView: UITextView {
        return lessonContentView.subviews.compactMap { $0 as? UITextView }.first!
    }
    
    internal let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/600자"
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let recordFileView: UIView = {
        let view = UIView()
        let title = UILabel()
        let field = CustomTextField()
        let uploadButton = UIButton()
        
        title.text = "녹음 파일"
        title.font = UIFont(name: "SUIT-Regular", size: 14)
        title.textColor = UIColor.white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        field.text = nil
        field.isUserInteractionEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        uploadButton.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration), for: .normal)
        uploadButton.tintColor = .white
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(title)
        view.addSubview(field)
        view.addSubview(uploadButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor),
            
            field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -3),
            field.heightAnchor.constraint(equalToConstant: 40),
            field.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            field.trailingAnchor.constraint(equalTo: uploadButton.leadingAnchor, constant: -5),
            
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uploadButton.widthAnchor.constraint(equalToConstant: 35),
            uploadButton.heightAnchor.constraint(equalToConstant: 40),
            uploadButton.centerYAnchor.constraint(equalTo: field.centerYAnchor, constant: -2),
        ])
        
        return view
    }()
    
    internal var uploadButton: UIButton {
        return recordFileView.subviews.compactMap { $0 as? UIButton }.first!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexCode: "111111")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(lessonDateView)
        contentView.addSubview(titleView)
        contentView.addSubview(lessonSongView)
        contentView.addSubview(lessonContentView)
        contentView.addSubview(textCountLabel)
        contentView.addSubview(recordFileView)
    }
    
    override func setConstraints() {
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            lessonDateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            lessonDateView.widthAnchor.constraint(equalToConstant: 130),
            lessonDateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            lessonDateView.heightAnchor.constraint(equalToConstant: 60),
            
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            titleView.topAnchor.constraint(equalTo: lessonDateView.bottomAnchor, constant: 20),
            titleView.heightAnchor.constraint(equalToConstant: 65),
            
            lessonSongView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            lessonSongView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            lessonSongView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            lessonSongView.heightAnchor.constraint(equalToConstant: 65),
            
            lessonContentView.leadingAnchor.constraint(equalTo: lessonSongView.leadingAnchor),
            lessonContentView.trailingAnchor.constraint(equalTo: lessonSongView.trailingAnchor),
            lessonContentView.topAnchor.constraint(equalTo: lessonSongView.bottomAnchor, constant: 20),
            lessonContentView.heightAnchor.constraint(equalToConstant: 250),
            
            textCountLabel.trailingAnchor.constraint(equalTo: lessonContentView.trailingAnchor, constant: -10),
            textCountLabel.widthAnchor.constraint(equalToConstant: 100),
            textCountLabel.topAnchor.constraint(equalTo: lessonContentView.bottomAnchor, constant: 5),
            
            recordFileView.leadingAnchor.constraint(equalTo: lessonContentView.leadingAnchor),
            recordFileView.trailingAnchor.constraint(equalTo: lessonContentView.trailingAnchor),
            recordFileView.topAnchor.constraint(equalTo: lessonContentView.bottomAnchor, constant: 30),
            recordFileView.heightAnchor.constraint(equalToConstant: 65),
            
            contentView.bottomAnchor.constraint(equalTo: recordFileView.bottomAnchor, constant: 30),
        ])
        
    }
    
}
