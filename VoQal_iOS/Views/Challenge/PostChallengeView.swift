//
//  PostChallengeView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit

class PostChallengeView: BaseView {

    private let dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        return view
    }()
    
    internal let closeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 17)
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.layer.cornerRadius = 10.0
        button.layer.cornerCurve = .continuous
        
        return button
    }()
    
    private let recordFileField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5.0
        textField.layer.cornerCurve = .continuous
        textField.layer.borderColor = UIColor(hexCode: "474747", alpha: 1.0).cgColor
        textField.layer.borderWidth = 2.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let uploadRecordFileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let uploadThumbnailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let songTitleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let artistField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        
    }
    
    override func setConstraints() {
        
    }

}
