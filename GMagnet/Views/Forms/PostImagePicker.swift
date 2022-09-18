

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
