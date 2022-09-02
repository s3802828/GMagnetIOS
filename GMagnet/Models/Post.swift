//
//  Post.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase

struct Post: Identifiable{
    let id: String
    let user: User
    let game: GameForum
    let title: String
    let content: String
    let image: String
    var liked_users: [User]
    var comment_list: [Comment]
    
    init(id: String, user: User, game: GameForum, title: String, content: String, image: String, liked_users: [User], comment_list: [Comment]){
        self.id = id
        self.user = user
        self.game = game
        self.title = title
        self.content = content
        self.image = image
        self.liked_users = liked_users
        self.comment_list = comment_list
    }
    
    init(user: User, game: GameForum, title: String, content: String, image: String, liked_users: [User], comment_list: [Comment]){
        self.id = "\(UUID())"
        self.user = user
        self.game = game
        self.title = title
        self.content = content
        self.image = image
        self.liked_users = liked_users
        self.comment_list = comment_list
    }
    
    init(){
        self.id = ""
        self.user = User(id: "", username: "", name: "", password: "", avatar: "", description: "", joined_forums: [""], posts: [""])
        self.game = GameForum()
        self.title = ""
        self.content = ""
        self.image = ""
        self.liked_users = [User]()
        self.comment_list = [Comment]()
    }
    
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
    
    static func get_posts(post_ids: [String])->[Post]{
        var posts_list: [Post] = []
        
        for post_id in post_ids{
            posts_list.append(Post.get_post(post_id: post_id))
        }
        
        return posts_list
    }
    
    static func add_post(added_post: Post){
        let db = Firestore.firestore()
        
        var post_owner = User.get_user(user_id: added_post.user.id)
        var updated_forum = GameForum.get_forum(forum_id: added_post.game.id)
        
        //add post to Post collection
        let new_id = db.collection("Post").addDocument(data: added_post.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
        
        // update user and game forum with new post id
        post_owner.posts.append(new_id.documentID)
        updated_forum.post_list.append(new_id.documentID)
        
        //update user and game forum with the new post id
        User.update_user(updated_user: added_post.user)
        GameForum.update_forum(updated_forum: added_post.game)
        
    }
    
    static func update_post(updated_post: Post){
        let db = Firestore.firestore()
        
        db.collection("Post").document(updated_post.id).setData(updated_post.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func delete_post(deleted_post: Post){
        let db = Firestore.firestore()
        
        var post_owner = User.get_user(user_id: deleted_post.user.id)
        var updated_forum = GameForum.get_forum(forum_id: deleted_post.game.id)
        
        if let post_index = post_owner.posts.firstIndex(where: {$0 == deleted_post.id}){
            post_owner.joined_forums.remove(at: post_index)
        }
        
        if let post_index = updated_forum.post_list.firstIndex(where: {$0 == deleted_post.id}){
            updated_forum.post_list.remove(at: post_index)
        }
        
        //update user and game forum with removed post id
        User.update_user(updated_user: post_owner)
        GameForum.update_forum(updated_forum: updated_forum)
        
        db.collection("Post").document(deleted_post.id).delete{ error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func get_post(post_id: String)->Post{
        let db = Firestore.firestore()
        var post: Post = Post()
        
        db.collection("Post").document(post_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    post =  Post(id: doc.documentID,
                                 user: User.get_user(user_id: data["user_id"] as? String ?? ""),
                                 game: GameForum.get_forum(forum_id: data["game_id"] as? String ?? ""),
                                 title: data["title"] as? String ?? "",
                                 content: data["content"] as? String ?? "",
                                 image: data["image"] as? String ?? "",
                                 liked_users: User.get_users(users_ids: data["liked_users"] as? [String] ?? [String]()),
                                 comment_list: Comment.get_comments(comment_ids: data["liked_users"] as? [String] ?? [String]())
                                )
                }
            }else{
                print("Doc does not exist")
                return
            }
        }
        
        return post
    }
    
    static func toggle_like_post(post: Post, user: User){
        // Call when user click Like/Unlike a post
        var updated_post = Post.get_post(post_id: post.id)
        
        if let user_index = updated_post.liked_users.firstIndex(where: {$0.id == user.id}){
            // if user have liked the post -> remove user and update post
            updated_post.liked_users.remove(at: user_index)
            Post.update_post(updated_post: updated_post)
            
        }else{
            // if user have not liked the post -> add user and update post
            updated_post.liked_users.append(user)
            Post.update_post(updated_post: updated_post)
        }
    }
}
