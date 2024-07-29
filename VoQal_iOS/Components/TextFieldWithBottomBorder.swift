import UIKit

class TextFieldWithBottomBorder: UITextField, UITextFieldDelegate {

    private let bottomBorder = CALayer()
    private let activeBorderColor = UIColor(hexCode: "D3D3D3", alpha: 1.0).cgColor
    private let inactiveBorderColor = UIColor(hexCode: "474747").cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.borderStyle = .none
        
        // Set up the bottom border
        bottomBorder.borderColor = inactiveBorderColor
        bottomBorder.borderWidth = 1.0
        layer.addSublayer(bottomBorder)
        layer.masksToBounds = true
        
        // Add target for editing events
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - bottomBorder.borderWidth, width: frame.size.width, height: bottomBorder.borderWidth)
    }
    
    @objc private func editingDidBegin() {
        bottomBorder.borderColor = activeBorderColor
    }
    
    @objc private func editingDidEnd() {
        bottomBorder.borderColor = inactiveBorderColor
    }
}
