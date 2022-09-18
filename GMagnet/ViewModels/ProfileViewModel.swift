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
  Created  date: 01/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
- Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
- Delete data from Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/delete-data
- Update a document: https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
- Wait until Firestore detdocuments()is finished before moving on - Swift: https://www.appsloveworld.com/swift/100/304/swiftui-wait-until-firestore-getdocuments-is-finished-before-moving-on
*/

//
//  ProfileViewModel.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation

// View Model for GamePage view and its children Views
class ProfileViewModel: ObservableObject{
    // user being displayed
    @Published var user: User = User()
    // variable keep track list of recent posts
    @Published var recent_posts: [Post] = []
    // variable keep track list of joined forums
    @Published var joined_forums: [GameForum] = []
    
    init(user_id: String){
        User.get_user(user_id: user_id){user in
            self.user = user
            self.get_joined_forums()
            self.get_recent_posts()
        }
    }
    
    //MARK: - refresh profile page
    func refreshPage(){
        User.get_user(user_id: user.id){user in
            self.user = user
            self.get_joined_forums()
            self.get_recent_posts()
        }
    }
    
    //MARK: - get all user's joined forum
    func get_joined_forums(){
        GameForum.get_forums(forum_ids: self.user.joined_forums){ joined_forums in
            self.joined_forums = joined_forums
        }
    }
    
    //MARK: - get all user's recent posts
    func get_recent_posts(){
        Post.get_posts(post_ids: self.user.posts){posts in
            self.recent_posts = posts
        }
    }
    
    //MARK: - update user and refresh UI
    func update_user(updated_user: User){
        User.update_user(updated_user: updated_user){user in
            self.user = user
        }
    }
    
    //MARK: - handle user like posts in profile page
    func toggle_like_post(post: Post, user: User){
        Post.toggle_like_post(post: post, user: user){post in
            // reload to update UI
            self.refreshPage()
        }
    }
    
    //MARK: - handle user update post in profile page
    func update_post(update_post: Post){
        Post.update_post(updated_post: update_post){ post in
            // call get posts again to update UI
            self.refreshPage()
        }
    }
    
    //MARK: - handle user delete post in profile page
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post){
            // call get posts again to update UI
            self.refreshPage()
        }
    }
    
    //MARK: - handle user delete forum in profile page
    func delete_forum(deleted_forum: GameForum){
        GameForum.delete_forum(deleted_forum: deleted_forum){
            self.refreshPage()
        }
    }

    //MARK: - handle user toggle join forum in profile page
    func toggle_join_forum(forum: GameForum, user: AuthenticateViewModel){
        // Call when user click Join/Unjoin on GamePage View
        GameForum.toggle_join_forum(forum: forum, user: user.currentUser){forum in
            self.refreshPage()
            user.refreshCurrentUser()
        }
    }
    
}
