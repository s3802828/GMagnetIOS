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
    @EnvironmentObject var mainViewModels: MainPageViewModel
    let updated_forum: GameForum
    @State private var isShowPhotoLibrary = false
    @State private var isShowBannerLibrary = false
    @State var isProgressing = false
    @State var imageKey: String = ""
    @State var image : UIImage = UIImage()
    @State var imageBanner: UIImage = UIImage()
    @State var bannerKey: String = ""
    @State var forumName: String = ""
    @State var description: String = ""
    @State var selectedTags: [Category] = []
    let gameColor = GameColor()
    
    init(updated_forum: GameForum){
        self.updated_forum = updated_forum
//        downloadImage(key: self.imageKey){result in
//            self.image = result
//        }
//        downloadImage(key: self.bannerKey){result in
//            self.imageBanner = result
//        }
        
    }
    
    func generate_img_key(link: String)->String{
        let split_arr = link.split(separator: "/")
        return split_arr.count>0 ? String(split_arr[split_arr.count - 1]) : ""
    }
    
    
    func downloadImage() {
        Amplify.Storage.downloadData(key: "gameIcon/\(self.imageKey)") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let unwrap_image = UIImage(data: data){
                        self.image = unwrap_image
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadBanner() {
        Amplify.Storage.downloadData(key: "gameBanner/\(self.bannerKey)") { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let unwrap_image = UIImage(data: data){
                        self.imageBanner = unwrap_image
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func submit_addform(){
        uploadImage()
    }
    
    func validate_form(){
        
    }
    
    func uploadImage() {
        
        let imageData = image.jpegData(compressionQuality: 1)!
        let bannerData = imageBanner.jpegData(compressionQuality: 1)!

        isProgressing = true
        
        if self.imageKey.contains("gameIcon/") && self.bannerKey.contains("gameBanner/"){
            Amplify.Storage.uploadData(key: imageKey, data: imageData, progressListener: { progress in
                print("Progress: \(progress)")
                
            }, resultListener: { event in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
    //                isProgressing = false
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            )
            
            Amplify.Storage.uploadData(key: bannerKey, data: bannerData, progressListener: { progress in
                print("Progress: \(progress)")
    //            isProgressing = true
            }, resultListener: { event in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                    
                    let updated_forum = GameForum(
                        id: self.updated_forum.id,
                        name: forumName,
                        description: description,
                        logo: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(imageKey)",
                        banner: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(bannerKey)",
                        admin: self.updated_forum.admin,
                        member_list: self.updated_forum.member_list,
                        post_list: self.updated_forum.post_list,
                        category_list: selectedTags
                    )
                    
                    mainViewModels.update_forum(updated_forum: updated_forum)
                    
                    isProgressing = false
                    
                    dismiss()
                    
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            )
        }else if self.imageKey.contains("gameIcon/"){
            Amplify.Storage.uploadData(key: imageKey, data: imageData, progressListener: { progress in
                print("Progress: \(progress)")
                
            }, resultListener: { event in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
    //                isProgressing = false
                    let updated_forum = GameForum(
                        id: self.updated_forum.id,
                        name: forumName,
                        description: description,
                        logo: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(imageKey)",
                        banner: self.updated_forum.banner,
                        admin: self.updated_forum.admin,
                        member_list: self.updated_forum.member_list,
                        post_list: self.updated_forum.post_list,
                        category_list: selectedTags
                    )
                    
                    mainViewModels.update_forum(updated_forum: updated_forum)
                    
                    isProgressing = false
                    
                    dismiss()
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            )
        }else if self.bannerKey.contains("gameBanner/"){
            Amplify.Storage.uploadData(key: bannerKey, data: bannerData, progressListener: { progress in
                print("Progress: \(progress)")
    //            isProgressing = true
            }, resultListener: { event in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                    
                    let updated_forum = GameForum(
                        id: self.updated_forum.id,
                        name: forumName,
                        description: description,
                        logo: self.updated_forum.logo,
                        banner: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(bannerKey)",
                        admin: self.updated_forum.admin,
                        member_list: self.updated_forum.member_list,
                        post_list: self.updated_forum.post_list,
                        category_list: selectedTags
                    )
                    
                    mainViewModels.update_forum(updated_forum: updated_forum)
                    
                    isProgressing = false
                    
                    dismiss()
                    
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            )
        }else{
            let updated_forum = GameForum(
                id: self.updated_forum.id,
                name: forumName,
                description: description,
                logo: self.updated_forum.logo,
                banner: self.updated_forum.banner,
                admin: self.updated_forum.admin,
                member_list: self.updated_forum.member_list,
                post_list: self.updated_forum.post_list,
                category_list: selectedTags
            )
            
            mainViewModels.update_forum(updated_forum: updated_forum)
        }
        

        
    }
    
    
    var body: some View {
        
        ZStack {
            
            VStack {
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        HStack (spacing: 2) {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }.padding(.horizontal, 10)
                    }
                    Spacer()
                }
                
                Text("Update forum")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .kerning(1.9)
                ScrollView{
                    VStack {
                        TextField("  Enter forum name", text: $forumName)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                        
                        TextEditor(text: $description)
                            .frame(height:250)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                        VStack {
                            Text("Select your forum tag")
                            TagSelectionView(selectedTags: self.$selectedTags)
                                .frame(height: 200)
                        }.padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                        
                        
                        
                        HStack {
                            Button(action: {
                                self.isShowPhotoLibrary = true
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                    
                                    Text("Add logo")
                                        .font(.headline)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                .background(gameColor.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                        
                            Image(uiImage: self.image)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 150, height: 150)
                        }
                        Spacer()
                            .sheet(isPresented: $isShowPhotoLibrary) {
                                ImagePicker(sourceType: .photoLibrary, img_path: "gameIcon", selectedImage: self.$image, imageName: self.$imageKey)
                        }
                            
                        HStack {
                            Button(action: {
                                self.isShowBannerLibrary = true
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                    
                                    Text("Add banner")
                                        .font(.headline)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                .background(gameColor.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                            Image(uiImage: self.imageBanner)
                                .resizable()
                                .frame(width: 150, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            
                        }
                        Spacer()
                            .sheet(isPresented: $isShowBannerLibrary) {
                            BannerPicker(sourceType: .photoLibrary, selectedBanner: self.$imageBanner, bannerName: $bannerKey)
                        }
                            
                        
                    }.padding(.top,5)
                }
                Spacer()
                Button(action: {
                    self.submit_addform()
                    
                }, label:{
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: gameColor.cyan.opacity(0.6), radius: 5, x: 0, y: 0)
                })
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top,10)
                
            }
            .padding()
            
            if isProgressing {
                ZStack {
                    Color(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(.all)
                        .opacity(0.4)

                    VStack {

                        
                        Text("Uploading...")
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.bold)
                            .frame(minWidth: 0, idealWidth: 280, maxWidth: 320, minHeight: 50, maxHeight: 50)
                        
                        ProgressView()
                        

                    }.frame(width: 300 , height: 100, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                }

            }
        }.onAppear(){
            self.description = self.updated_forum.description
            self.forumName = self.updated_forum.name
            self.selectedTags = self.updated_forum.category_list
            self.imageKey = self.generate_img_key(link: updated_forum.logo)
            self.bannerKey = self.generate_img_key(link: updated_forum.banner)
//            print("Ze state forum \(self.bannerKey)  \(self.forumName) \(self.description) \(self.imageKey) ")
            downloadImage()
            downloadBanner()
        }
        
        
    }
}

//struct UpdateForumView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateForumView()
//    }
//}
