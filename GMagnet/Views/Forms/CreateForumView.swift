//
//  CreateForumView.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 03/09/2022.
//

import SwiftUI

struct CreateForumView: View {
    @EnvironmentObject var mainViewModels: MainPageViewModel

    let curr_user: User
    @State private var isShowPhotoLibrary = false
    @State private var isShowBannerLibrary = false
    @State private var image = UIImage()
    @State private var imageBanner = UIImage()
    @State var forumName = ""
    @State var description = ""
    @State var selectedTags: [Category] = []
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    func submit_addform(){
        let new_forum = GameForum(
            id: "henloo",
            name: forumName,
            description: description,
            logo: "https://trainghiemso.vn/wp-content/uploads/2021/08/hades-thumb.webp",
            banner: "https://i0.wp.com/d9n64ieh9hz8y.cloudfront.net/wp-content/uploads/20201020214745/hades-danh-gia-game-1.jpg?fit=1920%2C870&ssl=1",
            admin: curr_user,
            member_list: [],
            post_list: [],
            category_list: selectedTags
        )
        
        mainViewModels.add_forum(added_forum: new_forum)
    }
    
    func validate_form(){
        
    }
    
    var body: some View {
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
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
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
                            .frame(width: 150, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        
                    }
                    Spacer()
                        .sheet(isPresented: $isShowBannerLibrary) {
                        BannerPicker(sourceType: .photoLibrary, selectedBanner: self.$imageBanner)
                    }
                        
                    
                }.padding(.top,5)
            }
            Spacer()
            Button(action: {
                self.submit_addform()
                dismiss()
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
    }
}

struct CreateForumView_Previews: PreviewProvider {
    static var previews: some View {
//        CreateForumView()
        HStack{}
    }
}
