//
//  CoachSelectionViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/9/24.
//

import UIKit

class CoachSelectionViewController: UIViewController {

    private let coachSelectionManager = CoachSelectionManager()
    private let coachSelectionView = CoachSelectionView()
    private var coaches : [Coach] = []
    
    override func loadView() {
        view = coachSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coachSelectionView.coachTableView.delegate = self
        coachSelectionView.coachTableView.dataSource = self
        
        coachSelectionManager.getCoachList { model in
            if model?.status == 200 {
                self.coaches = model?.coaches ?? [Coach(id: 0, name: "무명")]
                
            }
        }
        coachSelectionView.coachTableView.register(CoachSelectionTableViewCell.self, forCellReuseIdentifier: CoachSelectionTableViewCell.identifier)
        print("\(coaches.count)개의 셀")
    }
    
}

extension CoachSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return coaches.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoachSelectionTableViewCell.identifier, for: indexPath) as? CoachSelectionTableViewCell else {
            return UITableViewCell()
        }
//        let coachName = coaches[indexPath.row]
//        cell.configure(with: coachName.name)
        cell.configure(with: "박효신")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
