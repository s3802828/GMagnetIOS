//
//  PostViewModel.swift
//  GMagnet
//
//  Created by Phan Anh on 02/09/2022.
//

import Foundation

class PostViewModel: ObservableObject{
    @Published var post: Post
    @Published var comment_list: [Comment] = []
    
    init(post: Post){
        self.post = post
        self.fetch_comments()
    }
    func refreshPostViewModel(){
        Post.get_post(post_id: self.post.id){ post in
            self.post = post
            self.fetch_comments()
        }
    }
    func update_post(update_post: Post){
        Post.update_post(updated_post: update_post)
        
        // call get posts again to update UI
        self.refreshPostViewModel()
    }
    
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post)
        
        // call get posts again to update UI
        self.refreshPostViewModel()
    }
    
    func toggle_like_post(user: User){
        // Call when user click Like/Unlike on GamePage View
        Post.toggle_like_post(post: self.post, user: user)
        // call get posts again to update UI
        if let user_index = self.post.liked_users.firstIndex(where: {$0.id == user.id}){
            // if user have liked the post -> remove user and update post
            self.post.liked_users.remove(at: user_index)
        } else{
            // if user have not liked the post -> add user and update post
            self.post.liked_users.append(user)
        }
    }
    func fetch_comments(){
        self.comment_list = self.post.comment_list
    }
    
    func add_comment(added_comment: Comment){
        Comment.add_comment(added_comment: added_comment)
    }
    
    func update_comment(updated_comment: Comment){
        Comment.update_comment(updated_comment: updated_comment)
    }
    
    func delete_comment(deleted_comment: Comment){
        Comment.delete_comment(deleted_comment: deleted_comment)
    }
}
