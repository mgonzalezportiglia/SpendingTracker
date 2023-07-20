//
//  ImagePicker.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 17/02/2023.
//

import SwiftUI
import UIKit

struct SUImagePickerView: UIViewControllerRepresentable {
        
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Image?
    @Binding var isPresented: Bool
    @Binding var uiImageData: Data?
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(image: $image, isPresented: $isPresented, uiImageData: $uiImageData)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }
    
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: Image?
    @Binding var isPresented: Bool
    @Binding var uiImageData: Data?
    
    init(image: Binding<Image?>, isPresented: Binding<Bool>, uiImageData: Binding<Data?>) {
        self._image = image
        self._isPresented = isPresented
        self._uiImageData = uiImageData
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizedImage = image.resized(to: .init(width: 500, height: 500))
            self.uiImageData = resizedImage.jpegData(compressionQuality: 0.5)
            self.image = Image(uiImage: resizedImage)
        
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image {
            _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = max(hScale, vScale)
            let resizeSize = CGSize(width: size.width*scale, height: size.height*scale)
            var middle = CGPoint.zero
            
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width-newSize.width)/2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height-newSize.height)/2.0
            }
            
            draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}
