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
        Post.add_post(added_post: new_post)
        
        // call get posts again to update UI
        Post.get_posts(post_ids: self.gameforum.post_list){posts in
            self.posts = posts
        }
        
    }
    
    func update_post(update_post: Post){
        Post.update_post(updated_post: update_post)
        
        // call get posts again to update UI
        Post.get_posts(post_ids: self.gameforum.post_list){posts in
            self.posts = posts
        }
    }
    
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post)
        
        // call get posts again to update UI
        Post.get_posts(post_ids: self.gameforum.post_list){posts in
            self.posts = posts
        }
    }
    
    func toggle_like_post(post: Post, user: User){
        // Call when user click Like/Unlike on GamePage View
        Post.toggle_like_post(post: post, user: user)
        
        // call get posts again to update UI
        Post.get_posts(post_ids: self.gameforum.post_list){posts in
            self.posts = posts
        }
    }
    
    func toggle_join_forum(forum: GameForum, user: User){
        GameForum.toggle_join_forum(forum: forum, user: user)
        
        //reload UI
        Post.get_posts(post_ids: self.gameforum.post_list){posts in
            self.posts = posts
        }
        User.get_users(users_ids: self.gameforum.member_list){members in
            self.members = members
        }
    }
    

}
