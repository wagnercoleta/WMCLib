//
//  WMCPopUpScreen.swift
//  WMCLib
//
//  Created by Wagner Coleta on 15/07/22.
//

import UIKit

protocol WMCPopUpScreenProtocol: AnyObject {
    func actionFecharButton()
    func completionHide()
}

class WMCPopUpScreen: UIView {
    
    weak var delegate: WMCPopUpScreenProtocol?
    
    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.contentMode = .scaleAspectFit
        stack.spacing = 2
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .justified
        label.numberOfLines = 7
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fechar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    private func addElemented() {
        addSubview(self.backView)
        addSubview(self.contentView)
        self.stackView.addArrangedSubview(self.imageView)
        self.stackView.addArrangedSubview(self.descriptionLabel)
        self.stackView.addArrangedSubview(self.closeButton)
        self.contentView.addSubview(self.stackView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            self.backView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.contentView.centerXAnchor.constraint(equalTo: self.backView.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.backView.centerYAnchor),
            self.contentView.widthAnchor.constraint(equalToConstant: 300),
            self.contentView.heightAnchor.constraint(equalToConstant: 320),
            
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            
            self.closeButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.closeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.closeButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            self.closeButton.heightAnchor.constraint(equalToConstant: 38),
            
            self.imageView.widthAnchor.constraint(equalToConstant: 45),
            self.imageView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemRed
        self.addElemented()
        self.setupConstraint()
        self.setColorDefault(colorDefault: .systemBlue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonPressed() {
        self.delegate?.actionFecharButton()
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
    func setMessagem(message: String) {
        self.descriptionLabel.text = message
    }
    
    func setFont(font: UIFont) {
        self.descriptionLabel.font = font
        self.closeButton.titleLabel?.font = font
    }
    
    func setColorDefault(colorDefault: UIColor){
        self.imageView.tintColor = colorDefault
        self.closeButton.backgroundColor = colorDefault
    }
    
    func configView() {
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func show() {
        UIView.animate(withDuration: 0.5, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.delegate?.completionHide()
        }
    }
}
