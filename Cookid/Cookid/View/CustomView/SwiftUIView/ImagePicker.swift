//
//  ImagePicker.swift
//  TestHostingVC
//
//  Created by 임현지 on 2021/07/10.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                
//                let data = image.jpegData(compressionQuality: 0.2)
//                guard let data = data else { return }
//                do {
//                    let imageURL = try URL(dataRepresentation: data, relativeTo: nil)!
//                    print(imageURL)
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


