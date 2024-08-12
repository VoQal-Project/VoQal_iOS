//
//  CustomProgressView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/8/24.
//

import UIKit

protocol CustomProgressViewDelegate: AnyObject {
    func progressView(_ progressView: CustomProgressView, didUpdateProgress progress: Float)
}

class CustomProgressView: UIProgressView {
    weak var delegate: CustomProgressViewDelegate?
    private var current: Double?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateProgress(with: touches.first!)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        updateProgress(with: touches.first!)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        updateProgress(with: touches.first!)
    }
    
    private func updateProgress(with touch: UITouch) {
        current = touch.location(in: self).x
        progress = Float(current! / self.bounds.width)
        delegate?.progressView(self, didUpdateProgress: progress)
    }
}
