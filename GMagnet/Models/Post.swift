//
//  Post.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation

struct Post: Identifiable{
    let id: String
    let user: User
    let game: GameForum
    let title: String
    let content: String
    let image: String
    let liked_users: [User]
    let comment_list: [Comment]
    
    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase

        var liked_users_id: [String] = []
        var comment_list_id: [String] = []
        
        for liked_user in self.liked_users{
            liked_users_id.append(liked_user.id)
        }
        for user_comment in self.comment_list{
            comment_list_id.append(user_comment.id)
        }
        
        return [
            "user_id": self.user.id,
            "game_id": self.game.id,
            "title": self.title,
            "content": self.content,
            "image": self.image,
            "liked_user": liked_users_id,
            "comment_list": comment_list_id
        ]
    }
}

struct Comment: Identifiable{
    let id: String
    let user: User
    let post: Post
    let content: String
    
    func to_dictionary()->[String: Any]{
        return [
            "user_id": self.user.id,
            "post_id": self.post.id,
            "content": self.content
        ]
    }
}
