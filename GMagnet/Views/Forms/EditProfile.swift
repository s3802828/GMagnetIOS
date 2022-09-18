//
//  SignUpView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase
import Amplify
import UIKit

struct EditProfileView: View {
    
    @State var fullname = ""
    @State var email = ""
    @State var bio = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    @State var imageKey = ""
    @State var isProgressing = false
    
    @State var fullnameErrorMessage = ""
    @State var bioErrorMessage = ""
    @State var imageErrorMessage = ""
    
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var profile : ProfileViewModel
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    //MARK: - Get image key function
    func generate_img_key(link: String)->String{
        let split_arr = link.split(separator: "/")
        return split_arr.count>0 ? String(split_arr[split_arr.count - 1]) : ""
    }
    
    //MARK: - Download image data from s3 storage
    func downloadImage() {
        Amplify.Storage.downloadData(key: "userUpload/\(self.imageKey)") { result in
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
    
    //MARK: - Update user data function
    func update_user(){
        isProgressing = true
        
        //check if the user image is updated
        if self.imageKey.contains("userUpload/"){
            
            //compress UIImage into jpeg data
            let imageData = image.jpegData(compressionQuality: 1)!
            
            Amplify.Storage.uploadData(key: imageKey, data: imageData, progressListener: { progress in
                print("Progress: \(progress)")
                
            }, resultListener: { event in
                switch event {
                case .success(let data): //when upload image successfully
                    let updated_user = User(id: self.profile.user.id,
                                            username: self.profile.user.username,
                                            name: self.fullname,
                                            email: self.email,
                                            avatar: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/\(self.imageKey)",
                                            description: self.bio,
                                            joined_forums: self.profile.user.joined_forums,
                                            posts: self.profile.user.posts,
                                            longitude: self.profile.user.longitude,
                                            latitude: self.profile.user.latitude)
                    self.profile.update_user(updated_user: updated_user)
                    print("Completed: \(data)")
                    isProgressing = false
                    dismiss()

                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            )
            
            //Check if the user image is kept the same
        }else{
            let updated_user = User(id: self.profile.user.id,
                                    username: self.profile.user.username,
                                    name: self.fullname,
                                    email: self.email,
                                    avatar: self.profile.user.avatar,
                                    description: self.bio,
                                    joined_forums: self.profile.user.joined_forums,
                                    posts: self.profile.user.posts,
                                    longitude: self.profile.user.longitude,
                                    latitude: self.profile.user.latitude)
            self.profile.update_user(updated_user: updated_user)
            self.currentUser.refreshCurrentUser()
            isProgressing = false
            dismiss()

        }
        
    }
    
    //MARK: - Validation function
    func validate_form() {
        //Validate full name
        do {
            
            let pattern = #"^[A-Za-z0-9 '-]*$"#
            let nameRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: fullname.count)
            if (fullname == "") { //check when input is empty
                fullnameErrorMessage = "Must not be empty"
            } else if fullname.count > 100 { //check when input pass the letter limit
                fullnameErrorMessage = "Limit up to 100 letters"
            } else if nameRegex.firstMatch(in: fullname, range: range) != nil { //check if input matches the the regex pattern
                fullnameErrorMessage = ""
            } else {
                fullnameErrorMessage = "Invalid name (Special characters allowed: ' and - )"
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //Validate bio
        do {
            
            let pattern = #"^[A-Za-z0-9 '"!@#$%^&*()_+=.,:;?/\-\[\]{}|~]*$"#
            let nameRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: bio.count)
            if bio.count > 500 { //check when input pass the letter limit
                bioErrorMessage = "Limit up to 500 letters"
            } else if nameRegex.firstMatch(in: bio, range: range) != nil { //check if input matches the the regex pattern
                bioErrorMessage = ""
            } else {
                bioErrorMessage = "Invalid"
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //Validate image
        if let imageData = image.jpegData(compressionQuality: 1) {
            let imageSize = NSData(data: imageData).count
            if ((imageSize / 1000000) > 5) { //check if the selected image's size is over 5MB
                imageErrorMessage = "Size must be lower than 5MB"
            } else {
                imageErrorMessage = ""
            }
        }

        
    }
    
    var body: some View {
        ZStack{
            VStack{
                
                //MARK: - Cancel button
                HStack{
                    Button(action: {
                        dismiss()
                    }){
                        HStack (spacing: 2) {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }.padding(.horizontal, 5)
                    }
                    Spacer()
                }
                
                //MARK: - Header
                Text("Edit your profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .kerning(1.9)
                    .frame(maxWidth: .infinity,  alignment: .leading)
                VStack(alignment: .leading, spacing: 8, content: {
                    
                    //MARK: - Image picker for user avatar
                    HStack{
                        Button(action: {
                            self.isShowPhotoLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
                                
                                Text("Change Avatar")
                                    .font(.headline)
                            }
                            .frame(width: 200, height: 50)
                            .background(gameColor.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                        Image(uiImage: self.image)
                            .resizable()
                            
                            .frame(width: 100, height: 100 )
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        
                    }
                    .sheet(isPresented: $isShowPhotoLibrary) {
                        ImagePicker(sourceType: .photoLibrary, img_path: "userUpload", selectedImage: self.$image, imageName: $imageKey)
                    }
                    
                    //error message for post image
                    Text(imageErrorMessage)
                        .foregroundColor(.red)
                    
                    //MARK: - Full name input field
                    Text("Fullname")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    ZStack {
                        TextField("Pham Van A", text: $fullname) //label
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                        Text("\(fullname.count)/100") //letter counter
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .medium))
                            .offset(x: 145, y: 20)
                    }
                    
                    //error message for fullname input
                    Text(fullnameErrorMessage)
                        .foregroundColor(.red)
 
                })
                .padding(.top,5)
                VStack(alignment: .leading, spacing: 8){
                    Divider()
                        .padding(.top, 5)
                    Text("Username")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text("\(profile.user.username)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.black)
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text("\(profile.user.email)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.black)
                    Divider()
                        .padding(.top, 5)
                }
                
                
                //MARK: - Bio input field
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Bio") //label
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    ZStack {
                        TextEditor(text: $bio)
                            .frame(height:150)
                            .padding()
                            .background(Color.gray.opacity(0.3).cornerRadius(10))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                        Text("\(bio.count)/500") //letter counter
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .medium))
                            .offset(x: 135, y: 83)
                    }
                    
                    //error message for bio input
                    Text(bioErrorMessage)
                        .foregroundColor(.red)
                    
                    Divider()
                        .padding(.top, 5)
                })
                .padding(.top,10)
                
                Button(action: {
                    validate_form()
                    
                    //check if the error message of all the input fields is empty
                    if (fullnameErrorMessage == "" && bioErrorMessage == "" && imageErrorMessage == "") {
                        self.update_user()
                    }
                }, label:{
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: gameColor.cyan.opacity(0.6), radius: 5, x: 0, y: 0)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top,10)
                Spacer()
            }
            .padding()
            
            //MARK: - Loading screen display
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
            self.fullname = self.profile.user.name
            self.email = self.profile.user.email
            self.bio = self.profile.user.description
            if !self.profile.user.avatar.contains("googleusercontent"){
                self.imageKey = generate_img_key(link: self.profile.user.avatar)
                self.downloadImage()
            }
        }
        
        
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
