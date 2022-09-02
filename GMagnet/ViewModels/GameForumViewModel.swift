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
    @Published var gameforum: GameForum
    @Published var posts: [Post] = []
    @Published var members: [User] = []
    
    init(gameforum_id: String){
        self.gameforum = GameForum.get_forum(forum_id: gameforum_id)
    }
    
    func get_posts(){
        self.posts = Post.get_posts(post_ids: self.gameforum.post_list)
    }
    
    func get_members(forum_id: String){
        self.members = User.get_users(users_ids: self.gameforum.member_list)
    }
    
    func add_post(new_post: Post){
        Post.add_post(added_post: new_post)
        
        // call get posts again to update UI
        self.posts = Post.get_posts(post_ids: self.gameforum.post_list)
    }
    
    func update_post(update_post: Post){
        Post.update_post(updated_post: update_post)
        
        // call get posts again to update UI
        self.posts = Post.get_posts(post_ids: self.gameforum.post_list)
    }
    
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post)
        
        // call get posts again to update UI
        self.posts = Post.get_posts(post_ids: self.gameforum.post_list)
    }
    
    func toggle_like_post(post: Post, user: User){
        // Call when user click Like/Unlike on GamePage View
        Post.toggle_like_post(post: post, user: user)
        
        // call get posts again to update UI
        self.posts = Post.get_posts(post_ids: self.gameforum.post_list)
    }
    
    func toggle_join_forum(forum: GameForum, user: User){
        GameForum.toggle_join_forum(forum: forum, user: user)
        
        //reload UI
        self.gameforum = GameForum.get_forum(forum_id: self.gameforum.id)
        self.members = User.get_users(users_ids: self.gameforum.member_list)
    }
    

}
