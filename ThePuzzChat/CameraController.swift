//
//  CameraController.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 1/30/17.
//  Copyright © 2017 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

final class CameraController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let sharedInstance = CameraController()
    
    func TakePhoto(withCamera camera: UIImagePickerControllerCameraDevice) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = camera
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = [kCIAttributeTypeImage]
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kCIAttributeTypeImage) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                debugPrint(image)
            }
        }
    }
}
