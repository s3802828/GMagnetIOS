//
//  SignUpView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase

struct EditProfileView: View {
   
    @State var fullname = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    let gameColor = GameColor()
    
    var body: some View {

        
        VStack{
            
            Text("Edit your profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            Text("Input to edit your profile")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(Color.black)
            VStack(alignment: .leading, spacing: 8, content: {
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
                        .shadow(radius: 10)
                        
                }
                Spacer()
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                Text("Fullname")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("Pham van A", text: $fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                Text("User Name")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("ijustine@gmail.com", text: $email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,25)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Retype password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("12345", text: $confirmPassword)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            
            Button(action: {}, label:{
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
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
