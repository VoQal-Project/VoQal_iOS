//
//  SetLessonSongViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/27/24.
//

import UIKit

class SetLessonSongViewController: BaseViewController {
    
    var setLessonSongCompletion: (() -> Void)?
    
    private let setLessonSongView = SetLessonSongView()
    
    override func loadView() {
        view = setLessonSongView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func setAddTarget() {
        setLessonSongView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

    @objc private func didTapCloseButton() {
        print("Close Tap!")
        self.dismiss(animated: false)
    }

}
