//
//  TweetFilterViewModel.swift
//  PostList_IOS
//
//  Created by Dat Pham Thanh on 09/09/2022.
//

import Foundation

enum TweetFilterViewModel: Int, CaseIterable {
    case posts
    case joinedForum
    
    
    var title: String {
        switch self {
            case .posts: return "Posts"
            case .joinedForum: return "Joined Forum"
           
        }
    }
}
