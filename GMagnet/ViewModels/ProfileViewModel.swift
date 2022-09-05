//
//  ProfileViewModel.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation

// View Model for GamePage view and its children Views
class ProfileViewModel: ObservableObject{
    @Published var user: User = User()
    @Published var recent_posts: [Post] = []
    @Published var joined_forums: [GameForum] = []
    
    init(user_id: String){
        User.get_user(user_id: user_id){user in
            self.user = user
        }
    }
    
    func get_joined_forums(){
        GameForum.get_forums(forum_ids: self.user.joined_forums){ joined_forums in
            self.joined_forums = joined_forums
        }
    }
    
    func update_user(updated_user: User){
        User.update_user(updated_user: updated_user)
        self.user = updated_user
    }
    
    func toggle_like_post(post: Post, user: User){
        Post.toggle_like_post(post: post, user: user)
        
        // reload to update UI
        Post.get_posts(post_ids: self.user.posts){posts in
            self.recent_posts = posts
        }
    }
    
    func update_post(update_post: Post){
        Post.update_post(updated_post: update_post)
        
        // call get posts again to update UI
        Post.get_posts(post_ids: self.user.posts){posts in
            self.recent_posts = posts
        }
    }
    
    func delete_post(deleted_post: Post){
        Post.delete_post(deleted_post: deleted_post)
        
        // call get posts again to update UI
        Post.get_posts(post_ids: self.user.posts){posts in
            self.recent_posts = posts
        }
    }

    
    func toggle_join_forum(forum: GameForum, user: User){
        // Call when user click Join/Unjoin on GamePage View
        GameForum.toggle_join_forum(forum: forum, user: user)
        
        // reload to update UI
        Post.get_posts(post_ids: self.user.posts){posts in
            self.recent_posts = posts
        }
    }
    
}
