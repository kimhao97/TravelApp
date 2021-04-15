//
//  CustomTextField.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import UIKit
import RxSwift
import RxCocoa

class CustomTextField: UIView {
    
    @IBInspectable
    var isPassword: Bool = false {
        didSet {
            if isPassword {
                showPasswordButton.isHidden = false
                textField.isSecureTextEntry = true
            } else {
                showPasswordButton.isHidden = true
            }
        }
    }
    
    @IBInspectable
    var image: UIImage = UIImage() {
        didSet {
            textImage.image = image
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var notificationLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var textImage: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Func
    
    private func setupView() {
        showPasswordButton.setTitle("SHOW", for: .normal)
        showPasswordButton.setTitle("HIDE", for: .selected)
        
        textField.rx
            .controlEvent(.editingDidEnd)
            .withLatestFrom(textField.rx.text.orEmpty)
            .asDriver(onErrorJustReturn: "")
            .map { _ in true }
            .asDriver()
            .drive(showNotificationBinder)
            .disposed(by: disposeBag)
        
        textField.rx
            .controlEvent(.editingChanged)
            .map { false }
            .asDriver(onErrorJustReturn: false)
            .drive(showNotificationBinder)
            .disposed(by: disposeBag)
        
        
        
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        containerView.frame = bounds
        addSubview(containerView)
    }
    
    // MARK: - Action
    
    @IBAction func showPassword(sender: Any) {
        showPasswordButton.isSelected.toggle()
        
        if showPasswordButton.isSelected {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
    }

}

// MARK: - Extension

extension CustomTextField {
    private var showNotificationBinder: Binder<Bool> {
        return Binder(self) { view, isShowNotification in
            if isShowNotification {
                if let text = view.textField.text, text.isEmpty {
                    view.notificationLabel.text = "Invalid"
                    view.notificationLabel.isHidden = false
                }
            } else {
                view.notificationLabel.isHidden = true
            }
        }
    }
}
