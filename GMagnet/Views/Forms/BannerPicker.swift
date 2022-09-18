
import SwiftUI
import UIKit

struct BannerPicker: UIViewControllerRepresentable {

    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedBanner: UIImage
    @Binding var bannerName: String
    @Environment(\.presentationMode) private var presentationMode
    
    //Configure the UIImagePickerController initial state
    func makeUIViewController(context: UIViewControllerRepresentableContext<BannerPicker>) -> UIImagePickerController {
        
        let bannerPicker = UIImagePickerController()
                bannerPicker.allowsEditing = false
                bannerPicker.sourceType = sourceType
                bannerPicker.delegate = context.coordinator
         
                return bannerPicker
    }
    
    //Update the UIImagePickerController's state
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<BannerPicker>) {
    
    }
    
    //Instantiate Coordinator class
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //Get the selected image data and present it to SwiftUI view
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: BannerPicker
     
        init(_ parent: BannerPicker) {
            self.parent = parent
        }
     
        //Keep track of the user's selected photo
         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let banner = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedBanner = banner
            }
             
             if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                 parent.bannerName = "gameBanner/\(url.lastPathComponent)"
             }
     
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
