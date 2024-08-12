import UIKit

class CoachSelectionTableViewCell: UITableViewCell {

    static let identifier: String = "coachTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 65, weight: .regular)
        imageView.image = UIImage(systemName: "person.fill", withConfiguration: configuration)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "bottomBarColor")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CoachSelectionTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String) {
        let fullName = "\(name) 코치님"
        let attributedText = NSMutableAttributedString(string: fullName, attributes: [
            NSAttributedString.Key.kern: 1.5,
            NSAttributedString.Key.font: UIFont(name: "SUIT-SemiBold", size: 23)!
        ])
        
        // "코치님" 부분의 범위를 찾아서 작은 글씨로 설정
        let coachRange = (fullName as NSString).range(of: "코치님")
        attributedText.addAttributes([
            NSAttributedString.Key.font: UIFont(name: "SUIT-Regular", size: 17)!
        ], range: coachRange)
        
        // NSParagraphStyle을 사용하여 전체 텍스트 좌측 정렬 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        // NSParagraphStyle을 포함한 속성 추가
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        // UILabel에 적용
        nameLabel.attributedText = attributedText
    }
    // 이름만 좌로 정렬
    
    private func addSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            containerView.layer.borderWidth = 2.0
            containerView.layer.borderColor = UIColor.white.cgColor
        } else {
            containerView.layer.borderWidth = 0.0
            containerView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
