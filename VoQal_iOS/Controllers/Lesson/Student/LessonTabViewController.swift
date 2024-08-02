//
//  LessonTabViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import UIKit
import Pageboy
import Tabman

class LessonTabViewController: TabmanViewController {

    var viewControllers: Array<UIViewController> = [LessonNoteTableViewController(), RecordFileTableViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
        
    }
    
    private func settingTabBar(ctBar: TMBar.ButtonBar) {
        ctBar.layout.transitionStyle = .snap
        // 왼쪽 여백주기
        ctBar.layout.contentMode = .fit
        ctBar.layout.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        
        // 간격
//        ctBar.layout.interButtonSpacing = 35
        ctBar.backgroundView.style = .flat(color: UIColor(named: "mainBackgroundColor")!)
        
        
        // 선택 / 안선택 색 + font size
        ctBar.buttons.customize { (button) in
            button.tintColor = UIColor(hexCode: "474747")
            button.selectedTintColor = .white
            button.font = UIFont(name: "SUIT-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            button.selectedFont = UIFont(name: "SUIT-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        }
        
        // 인디케이터 (영상에서 주황색 아래 바 부분)
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = .white
    }

}

extension LessonTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "수업 일지")
        case 1:
            return TMBarItem(title: "녹음 파일")
        default:
            return TMBarItem(title: "page \(index)")
        }
    }
    
    
}
