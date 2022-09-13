//
//  UpdatePostView.swift
//  GMagnet
//
//  Created by Huu Tri on 12/09/2022.
//

import SwiftUI
import Firebase
import Amplify
import UIKit

struct UpdatePostView: View {
    let updated_post: Post
//    let currentUser: User
//    let gameForum: GameForum
    @EnvironmentObject var postViewModel : PostViewModel
    @State var titleInput = ""
    @State var contentInput = ""
    @State var isShowPostImageLibrary = false
    @State var postImage = UIImage()
    @State var postImageKey = ""
    @Environment(\.dismiss) var dismiss
    @State var isPostProgressing = false
    
    func generate_img_key(link: String)->String{
        let split_arr = link.split(separator: "/")
        return split_arr.count>0 ? String(split_arr[split_arr.count - 1]) : ""
    }
    
    func downloadPostImage() {
        if (self.postImageKey != "") {
            Amplify.Storage.downloadData(key: "postUpload/\(self.postImageKey)") { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        if let unwrap_image = UIImage(data: data){
                            self.postImage = unwrap_image
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
//    func add_post(){
//        if self.postImageKey.contains("postUpload/"){
//            let updated_post = Post(
//                user: updated_post.user,
//                game: updated_post.game,
//                title: self.titleInput,
//                content: self.contentInput,
//                image: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(postImageKey)",
//                liked_users: updated_post.liked_users,
//                comment_list: updated_post.comment_list,
//                createdAt: updated_post.createdAt)
//            self.postViewModel.update_post(update_post: updated_post)
//            uploadImage()
//        }else{
//            let updated_post = Post(
//                user: updated_post.user,
//                game: updated_post.game,
//                title: self.titleInput,
//                content: self.contentInput,
//                image: updated_post.image,
//                liked_users: updated_post.liked_users,
//                comment_list: updated_post.comment_list,
//                createdAt: updated_post.createdAt)
//            self.postViewModel.update_post(update_post: updated_post)
//            uploadImage()
//        }
//    }
    
    func uploadImage() {
        
        if self.postImageKey.contains("postUpload/"){
            let postImageData = postImage.jpegData(compressionQuality: 1)!
            isPostProgressing = true
            Amplify.Storage.uploadData(key: postImageKey, data: postImageData, progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { event in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                    let updated_post = Post(
                        id: updated_post.id,
                        user: updated_post.user,
                        game: updated_post.game,
                        title: self.titleInput,
                        content: self.contentInput,
                        image: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(postImageKey)",
                        liked_users: updated_post.liked_users,
                        comment_list: updated_post.comment_list,
                        createdAt: updated_post.createdAt)
                    self.postViewModel.update_post(update_post: updated_post)
                    
                    isPostProgressing = false
                    dismiss()
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            })
        }else{
            print("Case no image added")
            let updated_post = Post(
                id: updated_post.id,
                user: updated_post.user,
                game: updated_post.game,
                title: self.titleInput,
                content: self.contentInput,
                image: updated_post.image,
                liked_users: updated_post.liked_users,
                comment_list: updated_post.comment_list,
                createdAt: updated_post.createdAt)
            self.postViewModel.update_post(update_post: updated_post)
            
            isPostProgressing = false
            dismiss()
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
                
                Text("Update Post")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .kerning(1.9)
                    .frame(maxWidth: .infinity,  alignment: .center)
                    .padding(.horizontal, 10)
                
                Divider()
                HStack {
                    AsyncImage(url: URL(string: self.updated_post.game.logo)) {phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.gray))
                                .padding(.horizontal,5)
                                .id(-1)
                            
                        } else if phase.error != nil {
                            Image(systemName: "x.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.gray))
                                .padding(.horizontal,5)
                            
                        } else {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.gray))
                                .padding(.horizontal,5)
                            
                            
                        }
                    }
                    Text(self.updated_post.game.name)
                    
                    Spacer()
                    
                }.padding(5)
                Divider()
                TextField("Enter a title...", text: $titleInput)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 15)
                
                TextEditor(text: $contentInput)
                    .frame(height:200)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 15)
            
                if self.postImageKey != ""{
                    HStack {
                        Button(action: {
                            self.isShowPostImageLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
                                    
                                Text("Add Image")
                                    .font(.headline)
                            }
                            .frame(width: 150, height: 50)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.leading, 15)
                        }
                        Image(uiImage: self.postImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175)
                            .shadow(radius: 10)

                            
                    }
                    Spacer()
                    .sheet(isPresented: $isShowPostImageLibrary) {
                        PostImagePicker(sourceType: .photoLibrary, selectedPostImage: self.$postImage, postImageName: self.$postImageKey)
                    }
                }
                Spacer()

            }
            
            if isPostProgressing {
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
            
            VStack {
                Spacer()
                
                Button(action: {
                    self.uploadImage()
                }, label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .red, radius: 5, x: 0, y: 0)
                })
            }
            


        }.onAppear(){
            self.titleInput = self.updated_post.title
            self.contentInput = self.updated_post.content
            self.postImageKey = self.generate_img_key(link: self.updated_post.image)
            self.downloadPostImage()
        }
    }
}

//struct UpdatePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdatePostView()
//    }
//}
