//
//  RecordFileDetailViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/8/24.
//

import UIKit
import AVFoundation

class RecordFileDetailViewController: BaseViewController, CustomProgressViewDelegate {
    
    private let recordFileDetailView = RecordFileDetailView()
    private let studentRecordFileManager = StudentRecordFileManager()
    
    private var recordFileEntity: StudentRecordFile?
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    
    override func loadView() {
        view = recordFileDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recordFileEntity = recordFileEntity {
            recordFileDetailView.configure(recordFileEntity.recordTitle)
            if let url = URL(string: "\(PrivateUrl.shared.getS3UrlHead())\(recordFileEntity.s3Url)") {
                setupPlayer(with: url)
            }
        }
        
        recordFileDetailView.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        recordFileDetailView.audioProgressView.delegate = self
        recordFileDetailView.volumeProgressView.delegate = self
    }
    
    func setRecordFile(_ entity: StudentRecordFile) {
        self.recordFileEntity = entity
    }
    
    private func setupPlayer(with url: URL) {
            player = AVPlayer(url: url)
            
            timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
                guard let self = self, let duration = self.player?.currentItem?.duration else { return }
                let currentTime = CMTimeGetSeconds(time)
                let totalDuration = CMTimeGetSeconds(duration)
                self.recordFileDetailView.audioProgressView.progress = Float(currentTime / totalDuration)
            }
        }
    
    @objc private func playPauseButtonTapped() {
        guard let player = player else { return }
        
        if player.timeControlStatus == .playing {
            player.pause()
            recordFileDetailView.playPauseButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        } else {
            player.play()
            recordFileDetailView.playPauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        }
    }
    
    func progressView(_ progressView: CustomProgressView, didUpdateProgress progress: Float) {
        if progressView == recordFileDetailView.audioProgressView {
            guard let player = player, let duration = player.currentItem?.duration else { return }
            let totalDuration = CMTimeGetSeconds(duration)
            let newTime = totalDuration * Double(progress)
            player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
        } else if progressView == recordFileDetailView.volumeProgressView {
            player?.volume = progress
        }
    }

    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}
