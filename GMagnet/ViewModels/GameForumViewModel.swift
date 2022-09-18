/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 01/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
- Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
- Delete data from Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/delete-data
- Update a document: https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
- Wait until Firestore getdocuments() is finished before moving on - Swift: https://www.appsloveworld.com/swift/100/304/swiftui-wait-until-firestore-getdocuments-is-finished-before-moving-on
*/

import Foundation
import Firebase

// View Model for GamePage view and its children Views
class GameForumViewModel: ObservableObject{
    // the forum being displayed
    @Published var gameforum: GameForum = GameForum()
    // variable keep track list of game forum's post
    @Published var posts: [Post] = []
    // variable keep track list of game forum's members
    @Published var members: [User] = []
    
    init(gameforum_id: String){
        GameForum.get_forum(forum_id: gameforum_id){game_forum in
            self.gameforum = game_forum
            self.get_posts()
            self.get_members(forum_id: gameforum_id)
        }
    }
    
    // MARK: - function to update UI
    func refreshGameForum(completion: @escaping () -> Void) {
        GameForum.get_forum(forum_id: self.gameforum.id){ game_forum in
            self.gameforum = game_forum
            self.get_posts()
            self.get_members(forum_id: self.gameforum.id)
            completion()
        }
    }
    
    // MARK: - function to delete post and refresh UI
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post){
            // call get posts again to update UI
            self.refreshGameForum(){}
        }
    }
    
    // MARK: - function to fetch all posts to display
    func get_posts(){
        Post.get_posts(post_ids: self.gameforum.post_list){post_list in
            self.posts = post_list
        }
    }
    
    // MARK: - function to fetch all users to display
    func get_members(forum_id: String){
        User.get_users(users_ids: self.gameforum.member_list){users in
            self.members = users
        }
    }
    
    // MARK: - function to add post and refresh UI
    func add_post(new_post: Post){
        Post.add_post(added_post: new_post){
            // call get posts again to update UI
            self.refreshGameForum(){}
        }
    }
    
    
    // MARK: - function to handle user press join button and update UI
    func toggle_join_forum(forum: GameForum, authViewModel: AuthenticateViewModel){
        GameForum.toggle_join_forum(forum: forum, user: authViewModel.currentUser){forum in
            self.gameforum = forum
            //reload UI
            Post.get_posts(post_ids: self.gameforum.post_list){posts in
                self.posts = posts
            }
            User.get_users(users_ids: self.gameforum.member_list){members in
                self.members = members
            }
            authViewModel.refreshCurrentUser()
        }
    }
    
    
}
