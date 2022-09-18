/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 09/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 - Create an ImagePicker to choose a photo from the library or take a photo from the camera - https://designcode.io/swiftui-advanced-handbook-imagepicker
 - How to Access Photo Library and Use Camera in SwiftUI - https://www.appcoda.com/swiftui-camera-photo-library/
*/

import UIKit
import SwiftUI

struct PostImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedPostImage: UIImage
    @Binding var postImageName: String
    @Environment(\.presentationMode) private var presentationMode

    //Configure the UIImagePickerController initial state
    func makeUIViewController(context: UIViewControllerRepresentableContext<PostImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    //Update the UIImagePickerController's state
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PostImagePicker>) {
        
    }
    
    //Instantiate Coordinator class
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //Get the selected image data and present it to SwiftUI view
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PostImagePicker
        
        init(_ parent: PostImagePicker) {
            self.parent = parent
        }
        
        //Keep track of the user's selected photo
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedPostImage = image
            }
            
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                parent.postImageName = "postUpload/\(url.lastPathComponent)"
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
