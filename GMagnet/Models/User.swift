//
//  User.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation

struct User: Identifiable{
    let id: String
    let username: String
    let email: String
    let name: String
    let avatar: String
    let description: String
    let joined_forums: [GameForum]
    let posts: [Post]

    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase

        var joined_forums_ids: [String] = []
        var posts_ids: [String] = []
        
        for forum in self.joined_forums{
            joined_forums_ids.append(forum.id)
        }
        for post in self.posts{
            posts_ids.append(post.id)
        }
        
        return [
            "username": self.username,
            "name": self.name,
            "email": self.email,
            "avatar": self.avatar,
            "description": self.description,
            "joined_forums": joined_forums_ids,
            "posts": posts_ids
        ]
    }
}
