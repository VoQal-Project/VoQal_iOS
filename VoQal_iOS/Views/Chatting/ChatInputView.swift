import UIKit
import SwiftUI

class ChatInputTextView: UITextView {
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "메세지를 입력하세요"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) { fatalError("init(coder:)") }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.delegate = self
        self.isScrollEnabled = false
        self.font = UIFont(name: "SUIT-Regular", size: 16)
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        
        // Placeholder 추가
        addSubview(placeHolderLabel)
        
        // Placeholder에 대한 오토레이아웃 설정
        NSLayoutConstraint.activate([
            placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            placeHolderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // 텍스트 인셋 설정
        self.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.textContainer.lineFragmentPadding = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Placeholder 폰트 동기화
        placeHolderLabel.font = self.font
    }
}

// UITextViewDelegate 확장
extension ChatInputTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        }
    }
}

// SwiftUI PreviewProvider를 사용해 UIKit 뷰 미리보기
struct ChatInputTextView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let textView = ChatInputTextView()
            textView.frame = CGRect(x: 0, y: 0, width: 375, height: 100)
            return textView
        }
        .previewLayout(.sizeThatFits)
    }
}

// UIKit 뷰를 SwiftUI에서 미리보기 할 수 있게 하는 Helper Struct
struct UIViewPreview: UIViewRepresentable {
    let view: UIView
    
    init(_ builder: @escaping () -> UIView) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
