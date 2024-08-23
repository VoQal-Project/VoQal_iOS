//
//  PostChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit
import PhotosUI
import CropViewController

class PostChallengeViewController: BaseViewController, PHPickerViewControllerDelegate, CropViewControllerDelegate, UIDocumentPickerDelegate {

    private let postChallengeView = PostChallengeView()
    private let postChallengeManager = PostChallengeManager()
    private var recordFileURL: URL? = nil
    private var thumbnailImage: Data? = nil
    private var thumbnailName: String? = nil
    
    var postCompletion: (() -> Void)?
    
    override func loadView() {
        view = postChallengeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setAddTarget() {
        postChallengeView.uploadRecordFileButton.addTarget(self, action: #selector(didTapUploadRecordFileButton), for: .touchUpInside)
        postChallengeView.uploadThumbnailButton.addTarget(self, action: #selector(didTapUploadThumbnailButton), for: .touchUpInside)
        postChallengeView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        postChallengeView.postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
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
        // .post api request
        var errorFields: [String] = []
        
        if postChallengeView.getArtistValue() == "" { errorFields.append("가수명") }
        if postChallengeView.getSongTitleValue() == "" { errorFields.append("제목(곡 명)") }
        if self.thumbnailImage == nil { errorFields.append("대표 사진(썸네일)") }
        if self.recordFileURL == nil { errorFields.append("음성 파일") }
        
        if !errorFields.isEmpty {
            let alert = UIAlertController(title: "", message: "\(errorFields.joined(separator: ", "))을 입력해주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            self.present(alert, animated: false)
            return
        }
        
        postChallengeManager.postChallenge(thumbnail: self.thumbnailImage!, thumbnailName: self.thumbnailName!, songTitle: postChallengeView.getSongTitleValue()!, singer: postChallengeView.getArtistValue()!, fileURL: self.recordFileURL!) { model in
            guard let model = model else { print("postChallengeViewController - model 바인딩 실패"); return }
            
            if model.status == 200 {
                let alert = UIAlertController(title: "게시 완료!", message: "챌린지 게시가 완료되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.postCompletion?()
                    self.dismiss(animated: true)
                }))
                
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "게시 실패", message: "챌린지 게시에 실패했습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self.present(alert, animated: true)
            }
        } // 이전에 null인지 검사를 했으나 이를 그대로 쓸 방법을 찾아야함.
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
        self.postChallengeView.setupThumbnailImageView(image, self, #selector(didTapThumbnailImageView))
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
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.postChallengeView.resetThumbnailImageView()
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
            
            self.postChallengeView.setupRecordFileField(destinationURL)
            
        } catch {
            print("파일 복사 중 오류 발생: \(error)")
        }
    }
    
}
