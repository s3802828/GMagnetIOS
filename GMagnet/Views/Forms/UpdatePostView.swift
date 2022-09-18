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
    
    @State var titleErrorMessage = ""
    @State var contentErrorMessage = ""
    @State var postImageErrorMessage = ""
    
    @Environment(\.dismiss) var dismiss
    @State var isPostProgressing = false
    
    //MARK: - Get image key function
    func generate_img_key(link: String)->String{
        let split_arr = link.split(separator: "/")
        return split_arr.count>0 ? String(split_arr[split_arr.count - 1]) : ""
    }
    
    //MARK: - Download image data from s3 storage
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
    

    //MARK: - Upload image function
    func uploadImage() {
        
        //check if the post image is updated
        if self.postImageKey.contains("postUpload/"){
            
            //compress UIImage into jpeg data
            let postImageData = postImage.jpegData(compressionQuality: 1)!
            isPostProgressing = true
            Amplify.Storage.uploadData(key: postImageKey, data: postImageData, progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { event in
                switch event {
                case .success(let data): //when upload image successfully
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
            
        //Check if the post image is still the same
        }else{
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
    
    //MARK: - Validation function
    func validate_form() {
        //Validate title
        do {
            
            let pattern = #"^[A-Za-z0-9 '"!@#$%^&*()_+=.,:;?/\-\[\]{}|~]*$"#
            let titleRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: titleInput.count)
            if (titleInput == "") { //check when input is empty
                titleErrorMessage = "Must not be empty"
            } else if titleInput.count > 200 { //check when input pass the letter limit
                titleErrorMessage = "Limit up to 200 letters"
            } else if titleRegex.firstMatch(in: titleInput, range: range) != nil { //check if input matches the the regex pattern
                titleErrorMessage = ""
            } else {
                titleErrorMessage = "Invalid"
            }
            
        } catch let error {
            print(error.localizedDescription)
        }

        
        //Validate content
        
        do {
            
            let pattern = #"^[A-Za-z0-9 '"!@#$%^&*()_+=.,:;?/\-\[\]{}|~\n]*$"#
            let contentRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: contentInput.count)
            if (contentInput == "") { //check when input is empty
                contentErrorMessage = "Must not be empty"
            } else if contentInput.count > 1500 { //check when input pass the letter limit
                contentErrorMessage = "Limit up to 1500 letters"
            } else if contentRegex.firstMatch(in: contentInput, range: range) != nil { //check if input matches the the regex pattern
                contentErrorMessage = ""
            } else {
                contentErrorMessage = "Invalid"
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //Validate post image
        if let imageData = postImage.jpegData(compressionQuality: 1) {
            let imageSize = NSData(data: imageData).count
            if ((imageSize / 1000000) > 6) { //check if the selected image's size is over 6MB
                postImageErrorMessage = "Size must be lower than 6MB"
            } else {
                postImageErrorMessage = ""
            }
        }
        
        
    }

    var body: some View {
        ZStack {
            VStack {
                
                VStack {
                    //MARK: - Cancel button
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
                    
                    //MARK: - Header
                    Text("Update Post")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .kerning(1.9)
                        .frame(maxWidth: .infinity,  alignment: .center)
                        .padding(.horizontal, 10)
                    
                    Divider()
                    HStack {
                        //MARK: - Post image
                        AsyncImage(url: URL(string: self.updated_post.game.logo)) {phase in
                            if let image = phase.image { //if the image loaded successfully
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.gray))
                                    .padding(.horizontal,5)
                                    .id(-1)
                                
                            } else if phase.error != nil { //if the image loading failed
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.gray))
                                    .padding(.horizontal,5)
                                    .id(-1)
                                
                            } else { // if the image is loading
                                ProgressView()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.gray))
                                    .padding(.horizontal,5)
                                    .id(-1)
                                
                                
                            }
                        }
                        Text(self.updated_post.game.name)
                        
                        Spacer()
                        
                    }.padding(5)
                    Divider()
                    
                    //MARK: - Post title input field
                    ZStack {
                        TextField("Enter a title...", text: $titleInput) //label
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 15)
                        Text("\(titleInput.count)/200") //letter counter
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .medium))
                            .offset(x: 145, y: 20)
                    }
                    
                    //error message for post title
                    Text(titleErrorMessage)
                        .foregroundColor(.red)
                    
                    //MARK: - Post content field
                    ZStack {
                        TextEditor(text: $contentInput) //label
                            .frame(height:200)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 15)
                        Text("\(contentInput.count)/1500") //letter counter
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .medium))
                            .offset(x: 135, y: 107)
                    }
                    
                    //error message for post content
                    Text(contentErrorMessage)
                        .foregroundColor(.red)
                }
                
                
                VStack{
                    if self.postImageKey != ""{
                        
                        //MARK: - Image picker for user avatar
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
                        
                        //error message for post image
                        Text(postImageErrorMessage)
                            .foregroundColor(.red)
                    }
                }
            
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Button(action: {

                        validate_form()
                        //check if the error message of all the input fields is empty
                        if (titleErrorMessage == "" && contentErrorMessage == "" && postImageErrorMessage == "") {
                            self.uploadImage()
                        }
                        
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


            }
            
            
            //MARK: - Loading screen display
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
