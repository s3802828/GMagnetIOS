/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 11/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 - Uploading Files from iOS to Amazon S3: https://www.kiloloco.com/articles/011-uploading-files-from-ios-to-amazon-s3/
 - Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
 - Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
 - Delete data from Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/delete-data
 - Update a document: https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
 - SwiftUI 2.0 Material Design TextField - How to limit text In TextField? - SwiftUI Tutorials: https://www.youtube.com/watch?v=Gp2rhMApiqA
*/

import SwiftUI
import Firebase

struct AddComment: View {
    @State var commentInput = ""
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var postDetail : PostViewModel
    
    //MARK: - Add comment function
    func add_comment(){
        
        if self.commentInput.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            let new_comment = Comment(
                id: "ayo",
                user: currentUser.currentUser,
                post: postDetail.post.id,
                content: commentInput,
                createdAt: Timestamp.init()
            )
            postDetail.add_comment(added_comment: new_comment)
            commentInput = ""
        }
    }
    
    var body: some View {
        ZStack {
            
            HStack{
                //MARK: - Display user's avatar
                AsyncImage(url: URL(string: currentUser.currentUser.avatar)) {phase in
                    if let image = phase.image { //image successfully loaded
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)

                    } else if phase.error != nil { //image failed loading
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)

                    } else { //image is loading
                        ProgressView()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)
                    }
                }
                //MARK: - Add comment input field
                HStack {
                    
                    TextField("Add a comment...", text: $commentInput)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    Button(action: {
                        self.add_comment()
                    }, label: {
                        Image(systemName: "paperplane")
                        
                    })
                    
                }
                .padding(.horizontal, 10)
                .frame(height: 40)
                .overlay(Capsule().stroke().opacity(0.3))
                .padding(.horizontal, 10)
            }
        }
    }
}
