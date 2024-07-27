//
//  UploadRecordViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/25/24.
//

import UIKit


class UploadRecordViewController: BaseViewController {
    
    private let uploadRecordView = UploadRecordView()
    private let selectedFileURL: URL
    var uploadRecordCompletion : ( (_ fileURL: URL, _ title: String) -> Void )?
    
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
        guard let title = uploadRecordView.titleField.text else { print("녹음 파일 업로드 뷰에서의 값이 누락되었습니다."); return }
        
        self.dismiss(animated: true) {
            self.uploadRecordCompletion?(self.selectedFileURL, title)
        }
    }
    
}
