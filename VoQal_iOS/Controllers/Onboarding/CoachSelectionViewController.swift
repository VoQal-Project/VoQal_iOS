import UIKit

class CoachSelectionViewController: BaseViewController {

    private let coachSelectionManager = CoachSelectionManager()
    private let coachSelectionView = CoachSelectionView()
    private var coaches: [Coach] = []
    private var selectedIndex: Int? = nil

    override func loadView() {
        view = coachSelectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        coachSelectionView.coachTableView.delegate = self
        coachSelectionView.coachTableView.dataSource = self

        coachSelectionView.coachTableView.register(CoachSelectionTableViewCell.self, forCellReuseIdentifier: CoachSelectionTableViewCell.identifier)
        
        coachSelectionManager.getCoachList { model in
            if model?.status == 200, let coaches = model?.coaches {
                self.coaches = coaches
                print("\(coaches.count)개의 셀")
                DispatchQueue.main.async {
                    self.coachSelectionView.coachTableView.reloadData()
                }
            } else {
                print("코치를 불러오는 데에 실패하였습니다.")
            }
        }
    }
    
    override func setAddTarget() {
        coachSelectionView.applyCoachButton.addTarget(self, action: #selector(didTapApplyCoachButton), for: .touchUpInside)
    }
    
    @objc private func didTapApplyCoachButton() {
        
        print("\(Int(selectedIndex!))번째 코치의 coachId는 \(coaches[selectedIndex!].id)")
        
        if let selectedIndex = selectedIndex {
            coachSelectionManager.applyCoach(coaches[selectedIndex].id) { model in
                if let model = model {
                    if model.status == 200 {
                        
                        let alert = UIAlertController(title: "신청 완료", message: "신청이 완료되었습니다.\n담당 코치님으로부터 승인될 때까지 기다려주세요!\n 로그인 페이지로 이동합니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: false)
                    }
                    else {
                        let alert = UIAlertController(title: "", message: "담당 코치 신청에 실패했습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(alert, animated: false)
                    }
                }
                else {
                    let alert = UIAlertController(title: "", message: "담당 코치 신청에 실패했습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: false)
                }
            }
        }
        
    }
    
    
}



extension CoachSelectionViewController: UITableViewDelegate, UITableViewDataSource {
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
