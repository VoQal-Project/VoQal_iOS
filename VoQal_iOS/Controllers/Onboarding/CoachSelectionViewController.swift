//
//  CoachSelectionViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/9/24.
//

import UIKit

class CoachSelectionViewController: UIViewController {

    let coachSelectionView = CoachSelectionView()
    
    override func loadView() {
        view = coachSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
