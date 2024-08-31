//
//  ChangeCoachViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/25/24.
//

import UIKit

class ChangeCoachViewController: BaseViewController {
    
    private let changeCoachView = ChangeCoachView()
    private let changeCoachManager = ChangeCoachManager()
    private var selectedIndex: Int? = nil
    
    private var coaches: [Coach] = []
    
    override func loadView() {
        view = changeCoachView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        changeCoachView.coachTableView.dataSource = self
        changeCoachView.coachTableView.delegate = self
        changeCoachView.coachTableView.register(CoachSelectionTableViewCell.self, forCellReuseIdentifier: CoachSelectionTableViewCell.identifier)
        
        changeCoachManager.getCoachList { model in
            guard let model = model else { print("changeCoachViewController - getCoachList model 바인딩 실패"); return }
            
            if model.status == 200 {
                guard let coaches = model.data else { print("model.data가 nil입니다."); return }
                
                self.coaches = coaches
                self.changeCoachView.coachTableView.reloadData()
            }
        }
    }
    
    override func setAddTarget() {
        changeCoachView.changeCoachButton.addTarget(self, action: #selector(didTapChangeCoachButton), for: .touchUpInside)
    }
    
    
    
    @objc private func didTapChangeCoachButton() {
        guard let selectedIndex = self.selectedIndex else { print("selectedIndex is nil - 담당 코치 변경"); return }
        print("새 코치 id: \(coaches[selectedIndex].id)")
        changeCoachManager.changeCoach(coachId: coaches[selectedIndex].id) { model in
            guard let model = model else { print("changeCoach model 바인딩 실패"); return }
            
            if model.status == 200 {
                let alert = UIAlertController(title: "담당 코치 신청 완료!", message: "새 담당코치님의 승인을 기다리는 중입니다. 승인 후에 담당 코치 변경이 반영되니 기다려주세요!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                self.present(alert, animated: false)
            }
            else {
                print("changeCoach - model.status is not 200")
            }
        }
    }
    
}

extension ChangeCoachViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coaches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoachSelectionTableViewCell.identifier, for: indexPath) as? CoachSelectionTableViewCell else {
            return UITableViewCell()
        }
        let coachName = coaches[indexPath.row]
        cell.configure(with: coachName.name)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CoachSelectionTableViewCell {
            cell.setSelected(true, animated: true)
            selectedIndex = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CoachSelectionTableViewCell {
            cell.setSelected(false, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // 셀 높이를 늘려서 간격을 확보
    }
    
}
