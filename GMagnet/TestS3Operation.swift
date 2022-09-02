//
//  TestS3Operation.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI
import Amplify

struct TestS3Operation: View {
    
    let imageKey: String = "gameIcon/pencil-icon"
    let secondImageKey: String = "gameIcon/eraser-icon"
    
    @State var image: UIImage?
    @State var secondImage: UIImage?
    
    func uploadImage() {
        let houseImage = UIImage.init(named: "genshin-icon")!
        let houseImageData = houseImage.jpegData(compressionQuality: 1)!
        
        let secondImage = UIImage.init(named: "genshin-banner")!
        let secondImageData = secondImage.jpegData(compressionQuality: 1)!

        Amplify.Storage.uploadData(key: imageKey, data: houseImageData, progressListener: { progress in
            print("Progress: \(progress)")
        }, resultListener: { event in
            switch event {
            case .success(let data):
                print("Completed: \(data)")
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        )
        
        Amplify.Storage.uploadData(key: secondImageKey, data: secondImageData, progressListener: { progress in
            print("Progress: \(progress)")
        }, resultListener: { event in
            switch event {
            case .success(let data):
                print("Completed: \(data)")
                
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        )
        
    }
    
//    func downloadImage() {
//        Amplify.Storage.downloadData(key: imageKey) { result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    self.image = UIImage(data: data)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    func removeImage() {
        Amplify.Storage.remove(key: imageKey) { event in
            switch event {
            case let .success(data):
                print("Completed: Deleted \(data)")
            case let .failure(storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            
            Button("Upload", action: uploadImage)
//            Button("Download", action: downloadImage)
            Button("Remove", action: removeImage)
        }
    }
}

struct TestS3Operation_Previews: PreviewProvider {
    static var previews: some View {
        TestS3Operation()
    }
}
