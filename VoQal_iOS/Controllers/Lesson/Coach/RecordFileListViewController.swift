//
//  RecordFileListViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import UIKit
import UniformTypeIdentifiers

class RecordFileListViewController: BaseViewController, UIDocumentPickerDelegate {

    private let recordFileListView = RecordFileListView()
    private let recordFileListManager = RecordFileListManager()
    
    private var studentId: Int? = nil
    internal var recordFileURL: URL? = nil
    private var recordFileList: [RecordFile] = []
    
    override func loadView() {
        view = recordFileListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordFileListView.tableView.delegate = self
        recordFileListView.tableView.dataSource = self
        
        recordFileListView.tableView.register(RecordFileListTableViewCell.self, forCellReuseIdentifier: RecordFileListTableViewCell.identifier)
        
    }
    
    override func setAddTarget() {
        recordFileListView.floatingButton.addTarget(self, action: #selector(didTapUploadRecordFileBtn), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecordFileList()
    }
    
    internal func setStudentId(studentId: Int) {
        self.studentId = studentId
    }
    
    private func fetchRecordFileList() {
        guard let studentId = studentId else { print("fetchRecordFileList - studentId is nil"); return }
        
        recordFileListManager.fetchRecordFileList(studentId) { [weak self] model in
            guard let model = model, let self = self else { print("fetchRecordFileList - model or self is nil"); return }
            
            if model.status == 200 {
                guard let data = model.data else { print("fetchRecordFileList - model.data is nil"); return }
                recordFileList = data
                
                recordFileListView.tableView.reloadData()
            }
        }
    }
    
    @objc private func didTapUploadRecordFileBtn() {
        print("uploadRecordFile Tap!")
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        // 선택된 파일 경로 확인
        print("Selected File URL: \(selectedFileURL)")
        
        // 보안 범위 시작
        guard selectedFileURL.startAccessingSecurityScopedResource() else {
            print("파일에 접근할 수 없습니다.")
            return
        }
        
        defer {
            // 보안 범위 종료
            selectedFileURL.stopAccessingSecurityScopedResource()
        }
        
        // 파일을 앱의 Documents 디렉토리로 복사
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        do {
            // 기존 파일이 있다면 삭제
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            // 파일 복사
            try fileManager.copyItem(at: selectedFileURL, to: destinationURL)
            self.recordFileURL = destinationURL
            
            // UploadRecordViewController로 전환
            let uploadRecordVC = UploadRecordViewController(selectedFileURL: destinationURL)
            uploadRecordVC.studentId = self.studentId
            uploadRecordVC.delegate = self
            uploadRecordVC.modalPresentationStyle = .overFullScreen
            present(uploadRecordVC, animated: true)
            
        } catch {
            print("파일 복사 중 오류 발생: \(error)")
        }
    }
    
}

extension RecordFileListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordFileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordFileListTableViewCell.identifier, for: indexPath) as? RecordFileListTableViewCell else { print("RecordFileListTableViewCell dequeue failed"); return UITableViewCell() }
        
        let recordFile = recordFileList[indexPath.row]
        
        cell.configureCell(title: recordFile.recordTitle, date: recordFile.recordDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            // 삭제 확인 알림창 표시
            let alert = UIAlertController(title: "녹음 파일 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                completion(false)
            }
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let recordFileId = self.recordFileList[indexPath.row].recordId
                
                // API 호출하여 서버에서 삭제
                self.recordFileListManager.deleteRecordFile(Int64(recordFileId)) { [weak self] model in
                    guard let self = self, let model = model else { return }
                    
                    if model.status == 200 {
                        // 로컬 배열에서도 삭제
                        self.recordFileList.remove(at: indexPath.row)
                        
                        // 테이블뷰에서 애니메이션과 함께 셀 삭제
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                completion(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        }
        
        // 삭제 버튼 커스터마이징
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

extension RecordFileListViewController: UploadRecordDelegate {
    func didFinishUploadingRecord() {
        fetchRecordFileList()
    }
}
