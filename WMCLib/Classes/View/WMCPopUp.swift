//
//  WMCPopUp.swift
//  WMCLib
//
//  Created by Wagner Coleta on 15/07/22.
//

import UIKit

public class WMCPopUp: UIViewController {
    
    private var screen: WMCPopUpScreen?
    
    private let message: String
    private let image: UIImage
    private let color: UIColor
    private let font: UIFont
    
    public init(message: String, image: UIImage = UIImage(), colorDefault: UIColor = .systemBlue,
         fontDefault: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)) {
        self.message = message
        self.image = image
        self.color = colorDefault
        self.font = fontDefault
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.screen = WMCPopUpScreen()
        self.screen?.setMessagem(message: self.message)
        self.screen?.setImage(image: self.image)
        self.screen?.setColorDefault(colorDefault: self.color)
        self.screen?.setFont(font: self.font)
        self.view = self.screen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screen?.delegate = self
        
        self.view.backgroundColor = .clear
        self.screen?.configView()
    }
    
    public func appear(sender: UIViewController){
        sender.present(self, animated: false) {
            self.screen?.show()
        }
    }
}

extension WMCPopUp: WMCPopUpScreenProtocol {
    func actionFecharButton() {
        self.screen?.hide()
    }
    
    func completionHide() {
        self.dismiss(animated: false)
        self.removeFromParent()
    }
}
