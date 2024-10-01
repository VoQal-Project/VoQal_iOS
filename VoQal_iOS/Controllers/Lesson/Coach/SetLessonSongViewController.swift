//
//  SetLessonSongViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/27/24.
//

import UIKit

class SetLessonSongViewController: BaseViewController {
    
    var setLessonSongCompletion: (() -> Void)?
    internal var studentId: Int?
    
    private let setLessonSongView = SetLessonSongView()
    private let setLessonSongManager = SetLessonSongManager()
    
    override func loadView() {
        view = setLessonSongView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func setAddTarget() {
        setLessonSongView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        setLessonSongView.completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }

    @objc private func didTapCloseButton() {
        print("Close Tap!")
        self.dismiss(animated: false)
    }
    
    @objc private func didTapCompleteButton() {
        print("complete tap!")
        
        guard let studentId = self.studentId,
              let lessonSongUrl = setLessonSongView.urlTitleField.text,
              let singer = setLessonSongView.artistField.text,
              let songTitle = setLessonSongView.songTitleField.text else {
            print("didTapCompleteButton - 일부 값이 nil입니다.")
            return
        }
        
        if lessonSongUrl.isEmpty || singer.isEmpty || songTitle.isEmpty {
            let alert = UIAlertController(title: "설정 실패", message: "모든 필드에 값을 채워주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        if !isValidYouTubeURL(lessonSongUrl) {
            let alert = UIAlertController(title: "유효하지 않은 링크", message: "올바른 YouTube 링크를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        setLessonSongManager.setLessonSong(studentId, lessonSongUrl, singer, songTitle) { model in
            guard let model = model else { print("didTapCompleteButton - model 바인딩 실패"); return }
            if model.status == 200 {
                self.dismiss(animated: true)
                self.setLessonSongCompletion?()
            }
            else {
                let alert = UIAlertController(title: "설정 실패", message: "잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func isValidYouTubeURL(_ url: String) -> Bool {
        let youtubeRegex = "^(https?://)?(www\\.)?(youtube\\.com|youtu\\.?be)/.+$"
        let youtubeTest = NSPredicate(format: "SELF MATCHES %@", youtubeRegex)
        return youtubeTest.evaluate(with: url)
    }

}


