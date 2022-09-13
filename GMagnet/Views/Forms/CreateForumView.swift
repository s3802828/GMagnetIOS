//
//  CreateForumView.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 03/09/2022.
//

import SwiftUI
import Amplify
import UIKit

struct CreateForumView: View {
    @EnvironmentObject var mainViewModels: MainPageViewModel

    let curr_user: User
    @State private var isShowPhotoLibrary = false
    @State private var isShowBannerLibrary = false
    @State var image = UIImage()
    @State var imageKey = ""
    @State var imageBanner = UIImage()
    @State var bannerKey = ""
    @State var forumName = ""
    @State var description = ""
    @State var selectedTags: [Category] = []
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    @State var isProgressing = false
    
    func submit_addform(){
        uploadImage()
        
    }
    
    func validate_form(){
        
    }
    
    func uploadImage() {
        
        let imageData = image.jpegData(compressionQuality: 1)!
        let bannerData = imageBanner.jpegData(compressionQuality: 1)!

        isProgressing = true
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
                
                let new_forum = GameForum(
                    id: "henloo",
                    name: forumName,
                    description: description,
                    logo: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(imageKey)",
                    banner: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(bannerKey)",
                    admin: curr_user,
                    member_list: [],
                    post_list: [],
                    category_list: selectedTags
                )
                
                mainViewModels.add_forum(added_forum: new_forum)
                
                isProgressing = false
                
                dismiss()
                
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        )

        
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
                
                Text("Create New Forum")
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
                                .scaledToFit()
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
                                .scaledToFit()
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
        }
        
        
    }
}

struct CreateForumView_Previews: PreviewProvider {
    static var previews: some View {
//        CreateForumView()
        HStack{}
    }
}
