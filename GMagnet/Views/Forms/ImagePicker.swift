import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    let img_path: String
    @Binding var selectedImage: UIImage
    @Binding var imageName: String
    @Environment(\.presentationMode) private var presentationMode

    //Configure the UIImagePickerController initial state
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    //Update the UIImagePickerController's state
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    //Instantiate Coordinator class
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //Get the selected image data and present it to SwiftUI view
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        //Keep track of the user's selected photo
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                
            }
            
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                parent.imageName = "\(parent.img_path)/\(url.lastPathComponent)"
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
