//
//  UploadRecordViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/25/24.
//

import UIKit


class UploadRecordViewController: BaseViewController {
    
    private let uploadRecordFileManager = UploadRecordFileManager()
    private let uploadRecordView = UploadRecordView()
    internal var studentId: Int?
    private let selectedFileURL: URL
    
    
    init(selectedFileURL: URL) {
        self.selectedFileURL = selectedFileURL
        super.init(nibName: nil, bundle: nil) // Call the designated initializer of the superclass
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func loadView() {
        view = uploadRecordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddTarget()
        uploadRecordView.configure(selectedFileURL)
    }
    
    override func setAddTarget() {
        uploadRecordView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        uploadRecordView.completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        print("Close Tap!")
        self.dismiss(animated: true)
    }
    
    @objc private func didTapCompleteButton() {
        guard let title = uploadRecordView.titleField.text,
              let studentId = self.studentId else { print("녹음 파일 업로드 뷰에서의 값이 누락되었습니다."); return }
        let date = DateUtility.convertSelectedDate(uploadRecordView.datePicker.date, true)

        print("업로드 요청 - studentId: \(studentId), recordDate: \(date), recordTitle: \(title), fileURL: \(selectedFileURL)")

        uploadRecordFileManager.uploadRecordFile(studentId: studentId, recordDate: date, recordTitle: title, fileURL: selectedFileURL) { model in
            guard let model = model else { print("didTapCompleteButton - model 바인딩 실패!"); return }
            
            if model.status == 200 {
                print("녹음 파일 업로드 성공!")
                self.dismiss(animated: true)
            }
            else {
                let alert = UIAlertController(title: "업로드 실패!", message: "잠시 후에 다시 시도해 주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
}
