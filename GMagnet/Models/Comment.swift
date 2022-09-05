//
//  Comment.swift
//  GMagnet
//
//  Created by Phan Anh on 02/09/2022.
//

import Foundation
import Firebase

struct Comment: Identifiable{
    let id: String
    let user: User
    let post: String
    let content: String
    
    init(id: String, user: User, post: String, content: String){
        self.id = id
        self.user = user
        self.post = post
        self.content = content
    }
    init(){
        self.id = ""
        self.user = User()
        self.post = ""
        self.content = ""
    }
    
    func to_dictionary()->[String: Any]{
        return [
            "user_id": self.user.id,
            "post_id": self.post,
            "content": self.content
        ]
    }
    
    static func get_comments(comment_ids: [String])-> [Comment]{
        var comment_list: [Comment] = []
        
//        let db = Firestore.firestore()
        for comment_id in comment_ids {
            comment_list.append(Comment.get_comment(comment_id: comment_id))
        }
        return comment_list
    }
                        
    static func get_comment(comment_id: String)-> Comment{
        let db = Firestore.firestore()
        var comment: Comment = Comment()
        
        db.collection("Comment").document(comment_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    comment = Comment(id: doc.documentID,
                                      user: User.get_user(user_id: data["user_id"] as? String ?? ""), post: data["post_id"] as? String ?? "",
                                      content: data["content"] as? String ?? "")
                }
            }else{
                print("Doc does not exist")
                return
            }
        }
        
        return comment
    }
    
    static func add_comment(added_comment: Comment){
        let db = Firestore.firestore()
        
        var updated_post = Post.get_post(post_id: added_comment.post)
        
        //add post to Post collection
        let new_id = db.collection("Comment").addDocument(data: added_comment.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
        
        // update user and game forum with new post id
        updated_post.comment_list.append(Comment.get_comment(comment_id: new_id.documentID))
        
        //update user and game forum with the new post id
        Post.update_post(updated_post: updated_post)
    }
    
    static func delete_comment(deleted_comment: Comment){
        let db = Firestore.firestore()
        
        var updated_post = Post.get_post(post_id: deleted_comment.post)
        
        if let comment_index = updated_post.comment_list.firstIndex(where: {$0.id == deleted_comment.id}){
            updated_post.comment_list.remove(at: comment_index)
        }
        
        Post.update_post(updated_post: updated_post)
        
        db.collection("Comment").document(deleted_comment.id).delete{error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func update_comment(updated_comment: Comment){
        let db = Firestore.firestore()
        
        db.collection("Comment").document(updated_comment.id).setData(updated_comment.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            }
        }
    }
                        
}

