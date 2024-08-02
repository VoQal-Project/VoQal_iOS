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
    
    override func loadView() {
        view = recordFileTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
//
//extension RecordFileTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}
