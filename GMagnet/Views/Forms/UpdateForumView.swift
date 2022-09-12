//
//  UpdateForumView.swift
//  GMagnet
//
//  Created by Huu Tri on 12/09/2022.
//

import SwiftUI
import Amplify
import UIKit


struct UpdateForumView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var imageKey = ""
    @State var image : UIImage? = UIImage()
    
    func downloadImage() {
        Amplify.Storage.downloadData(key: imageKey) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var body: some View {
        ZStack{
            Button(action: {
                dismiss()
            }, label: {
                Text("dismiss")
            })
        }
    }
}

struct UpdateForumView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateForumView()
    }
}
