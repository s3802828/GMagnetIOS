//
//  GameForumViewModel.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase

// View Model for GamePage view and its children Views
class GameForumViewModel: ObservableObject{
    @Published var gameforum: GameForum = GameForum()
    @Published var posts: [Post] = []
    @Published var members: [User] = []
    
    init(gameforum_id: String){
        GameForum.get_forum(forum_id: gameforum_id){game_forum in
            self.gameforum = game_forum
            self.get_posts()
            self.get_members(forum_id: gameforum_id)
        }
    }
    
    func refreshGameForum(completion: @escaping () -> Void) {
        GameForum.get_forum(forum_id: self.gameforum.id){ game_forum in
            self.gameforum = game_forum
            self.get_posts()
            self.get_members(forum_id: self.gameforum.id)
            completion()
        }
    }
    
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post){
            // call get posts again to update UI
            self.refreshGameForum(){}
        }
    }

    
    func get_posts(){
        Post.get_posts(post_ids: self.gameforum.post_list){post_list in
            self.posts = post_list
        }
    }
    
    func get_members(forum_id: String){
        User.get_users(users_ids: self.gameforum.member_list){users in
            self.members = users
        }
    }
    
    func add_post(new_post: Post){
        Post.add_post(added_post: new_post){
            // call get posts again to update UI
            self.refreshGameForum(){}
        }
}



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
