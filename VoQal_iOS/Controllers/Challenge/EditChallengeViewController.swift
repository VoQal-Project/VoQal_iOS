//
//  EditChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/7/24.
//

import UIKit
import PhotosUI
import CropViewController

class EditChallengeViewController: BaseViewController, PHPickerViewControllerDelegate, CropViewControllerDelegate, UIDocumentPickerDelegate {
    
    private let editChallengeView = EditChallengeView()
    private let editChallengeManager = EditChallengeManager()
    private var recordFileURL: URL? = nil
    private var thumbnailImage: Data? = nil
    private var thumbnailName: String? = nil
    private var challengePostId: Int64? = nil
    private var previousThumbnail: UIImage? = nil
    
    var editCompletion: (() -> Void)?
    
    override func loadView() {
        view = editChallengeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func setAddTarget() {
        editChallengeView.uploadRecordFileButton.addTarget(self, action: #selector(didTapUploadRecordFileButton), for: .touchUpInside)
        editChallengeView.uploadThumbnailButton.addTarget(self, action: #selector(didTapUploadThumbnailButton), for: .touchUpInside)
        editChallengeView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        editChallengeView.postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }

    func setValues(_ singer: String, _ songTitle: String, _ thumbnail: UIImage, _ challengePostId: Int64) {
        editChallengeView.setSongTitleValue(songTitle)
        editChallengeView.setArtistValue(singer)
        editChallengeView.setupThumbnailImageView(thumbnail, self, #selector(didTapThumbnailImageView))
        self.challengePostId = challengePostId
    }
    
    @objc private func didTapUploadRecordFileButton() {
        print("uploadRecordFile Tap!")
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    
    @objc private func didTapUploadThumbnailButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapPostButton() {
        editChallengeView.postButton.throttle(seconds: 3.0) { [weak self] in
            guard let self = self else { return }
            
            if let artist = self.editChallengeView.getArtistValue(), artist != "",
               let songTitle = self.editChallengeView.getSongTitleValue(), songTitle != ""
            {
                print("songTitle: \(songTitle), artist: \(artist)")
                self.editChallengeManager.editChallenge(thumbnail: self.thumbnailImage, thumbnailName: self.thumbnailName, songTitle: songTitle, singer: artist, fileURL: self.recordFileURL, challengePostId: self.challengePostId!) { model in
                    guard let model = model else { print("postChallengeViewController - model 바인딩 실패"); return }
                    
                    if model.status == 200 {
                        let alert = UIAlertController(title: "수정 완료!", message: "챌린지 수정이 완료되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.editCompletion?()
                            self.dismiss(animated: true)
                        }))
                        
                        self.present(alert, animated: true)
                    }
                    else {
                        let alert = UIAlertController(title: "수정 실패", message: "챌린지 수정에 실패했습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        
                        self.present(alert, animated: true)
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "", message: "곡명 혹은 가수명을 입력해주세요!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self.present(alert, animated: false)
            }
        }
    }
    
    

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let result = results.first {
            // 파일 이름 추출을 위해 loadFileRepresentation 사용
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                if let url = url {
                    let fileName = url.lastPathComponent // 파일 이름 추출
                    
                    // 이미지 로드
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let selectedImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.thumbnailName = fileName // 추출한 파일 이름 저장
                                self.presentImageCropper(with: selectedImage)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func presentImageCropper(with image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.customAspectRatio = CGSize(width: 3, height: 4)
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.editChallengeView.setupThumbnailImageView(image, self, #selector(didTapThumbnailImageView))
        if let jpegImage = image.jpegData(compressionQuality: 0.7) {
            self.thumbnailImage = jpegImage
        }
        
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    @objc private func didTapThumbnailImageView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self,
                let previousThumbnail = self.previousThumbnail else { return }
            self.editChallengeView.resetThumbnailImageView(previousThumbnail)
            self.thumbnailImage = nil
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
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
            
            self.editChallengeView.setupRecordFileField(destinationURL)
            
        } catch {
            print("파일 복사 중 오류 발생: \(error)")
        }
    }
}
