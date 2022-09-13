//
//  SignUpView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase
import UIKit

struct EditProfileView: View {
   
    @State var fullname = ""
    @State var email = ""
    @State var bio = ""
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    @State var imageKey = ""
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var profile : ProfileViewModel
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    var body: some View {
        VStack{
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
            Text("Edit your profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            VStack(alignment: .leading, spacing: 8, content: {
                HStack{
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
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, imageName: $imageKey)
                }
                Text("Fullname")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("Pham Van A", text: $fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
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
            })
            .padding(.top,5)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Bio")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextEditor(text: $bio)
                    .frame(height:150)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,10)
            
            Button(action: {
                dismiss()
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
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
