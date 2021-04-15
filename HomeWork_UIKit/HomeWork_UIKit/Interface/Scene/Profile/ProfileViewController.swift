//
//  ProfileViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

final class ProfileViewController: BaseViewController, UINavigationControllerDelegate {
    
    @IBOutlet private weak var userImage: UIImageView!
    
    private let imagePicker = UIImagePickerController()
    private let userManager = UserManager(userService: APIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupData() {
        super.setupData()
        
        imagePicker.delegate = self
        
        userManager.loadImage() { [ weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    self?.userImage.image = image
                }
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.navigationController?.isNavigationBarHidden = true
        
        userImage.makeRoundCorners(byRadius: 60)
    }
    
    @IBAction func changePhoto(sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            userImage.image = editedImage
        }
        
//        if let pickedImage = info[.originalImage] as? UIImage {
//            userImage.image = pickedImage
//        }

        dismiss(animated: true, completion: nil)
    }

}
