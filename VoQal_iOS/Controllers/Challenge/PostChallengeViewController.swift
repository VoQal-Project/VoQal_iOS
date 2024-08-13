//
//  PostChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit
import PhotosUI
import CropViewController

class PostChallengeViewController: BaseViewController, PHPickerViewControllerDelegate, CropViewControllerDelegate {

    private let postChallengeView = PostChallengeView()
    private var recordFile: URL? = nil
    private var thumbnailImage: UIImage? = nil
    
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
        if validateAllFields() {
            print("post success")
        }
        else {
            print("post failed!")
        }
    }
    
    private func validateAllFields() -> Bool {
        var errorFields: [String] = []
        
        if postChallengeView.getArtistValue() == "" { errorFields.append("가수명") }
        if postChallengeView.getSongTitleValue() == "" { errorFields.append("제목(곡 명)") }
        if self.thumbnailImage == nil { errorFields.append("대표 사진(썸네일)") }
        if self.recordFile == nil { errorFields.append("음성 파일") }
        
        if !errorFields.isEmpty {
            let alert = UIAlertController(title: "", message: "\(errorFields.joined(separator: ", "))을 입력해주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            self.present(alert, animated: false)
            
            return false
        }
        
        return true
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let result = results.first {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.presentImageCropper(with: selectedImage)
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
        thumbnailImage = image
        self.postChallengeView.setupThumbnailImageView(image)
        
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
}
