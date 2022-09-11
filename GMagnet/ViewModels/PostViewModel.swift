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
