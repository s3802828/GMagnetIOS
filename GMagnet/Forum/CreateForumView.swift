//
//  CreateForumView.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 03/09/2022.
//

import SwiftUI

struct CreateForumView: View {
    @State private var isShowPhotoLibrary = false
    @State private var isShowBannerLibrary = false
    @State private var image = UIImage()
    @State private var imageBanner = UIImage()
    @State var forumName = ""
    @State var description = ""
    @State var password = ""
    @State var confirmPassword = ""
    let gameColor = GameColor()
    @State private var selection = "FPS"
    let forumTag = ["FPS","Racing","Moba"]
    var body: some View {
        VStack{
            
            Text("Create new forum")
                .font(.system(size: 35))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
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
                HStack{
                    Text("Select your forum tag")
                    Picker("Select your forum tag: ", selection: $selection){
                        ForEach( forumTag, id: \.self){
                            Text($0)
                            
                        }
                        .pickerStyle(.menu)
                        
                    }
                }
                .padding()
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
                        .shadow(radius: 10)
                        
                }
                Spacer()
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
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
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        
                }
                Spacer()
                .sheet(isPresented: $isShowBannerLibrary) {
                    BannerPicker(sourceType: .photoLibrary, selectedBanner: self.$imageBanner)
                }
                
            }
            .padding(.top,50)
           
            
            
            Button(action: {}, label:{
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
                Spacer()
            }
        .padding()
    }
}

struct CreateForumView_Previews: PreviewProvider {
    static var previews: some View {
        CreateForumView()
    }
}
