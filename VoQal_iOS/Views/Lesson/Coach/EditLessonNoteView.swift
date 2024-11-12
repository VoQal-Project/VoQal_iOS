//
//  EditLessonNoteView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/12/24.
//

import UIKit

class EditLessonNoteView: BaseView {

    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
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
    
    internal var datePicker: UIDatePicker {
        return lessonDateView.subviews.compactMap { $0 as? UIDatePicker }.first!
    }
    
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
    
    internal var titleTextField: UITextField {
        return titleView.subviews.compactMap { $0 as? UITextField }.first!
    }
    
    fileprivate let lessonSongView: UIView = {
        let view = UIView()
        let title = UILabel()
        let artistTextField = CustomTextField()
        let songTitleTextField = CustomTextField()
        
        title.text = "레슨곡"
        title.font = UIFont(name: "SUIT-Regular", size: 14)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        artistTextField.placeholder = "가수명"
        artistTextField.translatesAutoresizingMaskIntoConstraints = false
        
        songTitleTextField.placeholder = "곡명"
        songTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        view.addSubview(artistTextField)
        view.addSubview(songTitleTextField)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor),
            
            artistTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -3),
            artistTextField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            artistTextField.heightAnchor.constraint(equalToConstant: 40),
            artistTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            
            songTitleTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
            songTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            songTitleTextField.topAnchor.constraint(equalTo: artistTextField.topAnchor),
            songTitleTextField.heightAnchor.constraint(equalTo: artistTextField.heightAnchor),
        ])
        
        return view
    }()
    
    internal var artistTextField: UITextField {
        return lessonSongView.subviews.compactMap { $0 as? UITextField }.first!
    }
    
    internal var songTitleTextField: UITextField? {
        let textFields = lessonSongView.subviews.compactMap { $0 as? UITextField }
        guard textFields.count > 1 else { return nil }
        return textFields[1]
    }

    internal let lessonContentView: UIView = {
        let view = UIView()
        let title = UILabel()
        let textView = UITextView()
        let textCountLabel = UILabel()
        
        title.text = "본문"
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
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexCode: "111111")
        addGestureRecognizer(tapGesture)
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        titleTextField.delegate = self
        artistTextField.delegate = self
        songTitleTextField?.delegate = self
    }

    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(lessonDateView)
        contentView.addSubview(titleView)
        contentView.addSubview(lessonSongView)
        contentView.addSubview(lessonContentView)
        contentView.addSubview(textCountLabel)
        
        setupKeyboardNotifications()
    }
    
    override func setConstraints() {
        
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollViewBottomConstraint!,
            
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
            
            contentView.bottomAnchor.constraint(equalTo: lessonContentView.bottomAnchor, constant: 70),
        ])
        
    }
    
    @objc private func dismissKeyboard() {
        print("외부 탭")
        endEditing(true)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        // 키보드 애니메이션 정보
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        
        // 현재 활성화된 텍스트필드나 텍스트뷰의 프레임을 가져옴
        guard let activeField = findFirstResponder() else { return }
        let convertedFrame = activeField.convert(activeField.bounds, to: self)
        
        // 활성화된 필드가 키보드에 가려지는지 계산
        let distanceToBottom = frame.height - convertedFrame.maxY
        let offset = keyboardHeight - distanceToBottom + 20 // 여유 공간
        
        if offset > 0 {
            UIView.animate(withDuration: duration) {
                self.scrollView.contentOffset.y += offset
            }
        }
        
        scrollViewBottomConstraint?.constant = -keyboardHeight
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        
        scrollViewBottomConstraint?.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
            // 스크롤뷰를 원래 위치로
            self.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    // 현재 First Responder인 뷰를 찾는 헬퍼 메서드
    private func findFirstResponder() -> UIView? {
        let fields: [UIView] = [titleTextField, artistTextField, songTitleTextField, contentViewTextView].compactMap { $0 }
        return fields.first { $0.isFirstResponder }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension EditLessonNoteView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            artistTextField.becomeFirstResponder()
        }
        else if textField == artistTextField {
            songTitleTextField?.becomeFirstResponder()
        }
        else if textField == songTitleTextField {
            contentViewTextView.becomeFirstResponder()
        }
        
        return true
    }
}
