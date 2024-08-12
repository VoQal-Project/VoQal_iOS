//
//  RecordFileTableViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import UIKit

class RecordFileTableViewController: UIViewController {

    private let recordFileTableView = RecordFileTableView()
    private let recordFileManager = StudentRecordFileManager()
    private var recordFiles: [StudentRecordFile] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recordFileTableView.tableView.reloadData()
            }
        }
    }
    
    override func loadView() {
        view = recordFileTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordFileTableView.tableView.register(StudentRecordFileTableViewCell.self, forCellReuseIdentifier: StudentRecordFileTableViewCell.identifier)
        recordFileTableView.tableView.delegate = self
        recordFileTableView.tableView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecordFiles()
    }
    
    private func fetchRecordFiles() {
            recordFileManager.fetchRecordFiles { [weak self] model in
                guard let self = self, let model = model else { return }
                
                if model.status == 200 {
                    Task {
                        await model.loadDurations {
                            DispatchQueue.main.async {
                                self.recordFiles = model.sortedData ?? []
                            }
                        }
                    }
                } else {
                    print("녹음 파일 조회 실패 - RecordFileTableViewController")
                }
            }
        }
    
    func formatDuration(_ duration: TimeInterval?) -> String {
        
        guard let duration = duration else { print("formatDuration - duration이 nil입니다."); return "Loading..." }
        
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

extension RecordFileTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(recordFiles.count)개의 셀")
        return recordFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentRecordFileTableViewCell.identifier, for: indexPath) as? StudentRecordFileTableViewCell else { print("RecordFileTableViewController - 셀 dequeueReusableCell 실패"); return UITableViewCell() }
        
        cell.configure(recordFiles[indexPath.row].recordTitle, recordFiles[indexPath.row].recordDate, formatDuration(recordFiles[indexPath.row].duration))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecordFileDetailViewController()
        vc.setRecordFile(self.recordFiles[indexPath.row])
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
