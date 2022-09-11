//
//  CreatePostView.swift
//  TestS3Upload
//
//  Created by Huu Tri on 09/09/2022.
//

import SwiftUI

struct CreatePostView: View {
    @EnvironmentObject var gameForum : GameForumViewModel
    @State var titleInput = ""
    @State var contentInput = ""
    @State var isShowPostImageLibrary = false
    @State var postImage = UIImage()
    @State var isPostingImage = false
    @Environment(\.dismiss) var dismiss

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
                
                Text("Create New Post")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .kerning(1.9)
                    .frame(maxWidth: .infinity,  alignment: .center)
                    .padding(.horizontal, 10)
                
                Divider()
                HStack {
                    AsyncImage(url: URL(string: gameForum.gameforum.banner)) {phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.gray))
                                .padding(.horizontal,5)
                                .id(-1)
                            
                        } else if phase.error != nil {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 280, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 9))
                                .overlay(RoundedRectangle(cornerRadius: 9).stroke(.gray))
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                            
                        } else {
                            ProgressView()
                                .frame(width: 280, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 9))
                                .overlay(RoundedRectangle(cornerRadius: 9).stroke(.gray))
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                            
                            
                        }
                    }
                    Text(gameForum.gameforum.name)
                    
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
            
                HStack{
                    Button(action: {
                        isPostingImage.toggle()
                        if !isPostingImage {
                            postImage = UIImage()
                        }
                    }, label: {
                        HStack {
                            Image(systemName: isPostingImage ? "checkmark.circle" : "circle")
                                .foregroundColor(isPostingImage ? .green : .black)
                            Text("Post with Image")
                        }
                        .foregroundColor(.black)
                        .padding(.all,6)
                        .background{
                            RoundedRectangle(cornerRadius: 10).stroke(.black)
                        }
                        
                    })
                    
                    Spacer()
                }.padding(.horizontal, 15)

                if isPostingImage {
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
                        PostImagePicker(sourceType: .photoLibrary, selectedPostImage: self.$postImage)
                    }
                }
                Spacer()

            }
            
            
            VStack {
                Spacer()
                
                Button(action: {
                    dismiss()
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
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
