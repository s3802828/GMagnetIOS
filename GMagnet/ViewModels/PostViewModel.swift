/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
- Le Quynh Giang (s3802828)
- Phan Truong Quynh Anh (s3818245)
- Ngo Huu Tri (s3818520)
- Pham Thanh Dat (s3678437)
  Created  date: 02/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
- Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
- Delete data from Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/delete-data
- Update a document: https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
- Wait until Firestore detdocuments()is finished before moving on - Swift: https://www.appsloveworld.com/swift/100/304/swiftui-wait-until-firestore-getdocuments-is-finished-before-moving-on
*/

//
//  PostViewModel.swift
//  GMagnet
//
//  Created by Phan Anh on 02/09/2022.
//

import Foundation

class PostViewModel: ObservableObject{
    // post being displayed
    @Published var post: Post
    // variable keep track list of comment lists
    @Published var comment_list: [Comment] = []
    
    init(post: Post){
        self.post = post
        self.fetch_comments()
    }
    
    //MARK: - func to refresh post page
    func refreshPostViewModel(completion: @escaping () -> Void){
        Post.get_post(post_id: self.post.id){ post in
            self.post = post
            self.fetch_comments()
            completion()
        }
    }
    
    //MARK: - func to update post and refresh UI
    func update_post(update_post: Post){
        Post.update_post(updated_post: update_post){post in
            // call get posts again to update UI
            self.refreshPostViewModel(){}
        }
    }
    
    //MARK: - func to handle user's toggle like and update UI
    func toggle_like_post(user: User){
        // Call when user click Like/Unlike on GamePage View
        Post.toggle_like_post(post: self.post, user: user){post in
            self.post = post
        }
    }
    
    //MARK: - func to fetch comments
    func fetch_comments(){
        self.comment_list = self.post.comment_list
    }
    
    //MARK: - func to add comment and refresh UI
    func add_comment(added_comment: Comment){
        Comment.add_comment(added_comment: added_comment){
            self.refreshPostViewModel(){}
        }
    }
    
    //MARK: - func to add comment and refresh UI
    func update_comment(updated_comment: Comment){
        Comment.update_comment(updated_comment: updated_comment){comment in
            self.refreshPostViewModel(){}
        }
    }
    
    //MARK: - func delete comment and refresh UI
    func delete_comment(deleted_comment: Comment){
        Comment.delete_comment(deleted_comment: deleted_comment){post in
            self.refreshPostViewModel(){}
        }
    }
}
