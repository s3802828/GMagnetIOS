/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 09/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 SwiftUI 2.0 Twitter Profile Page Parallax Animation + Sticky Headers - SwiftUI Tutorials - https://www.youtube.com/watch?v=U5UbLFmLUpU
*/

import Foundation

enum TweetFilterViewModel: Int, CaseIterable {
    case posts
    case joinedForum
    
    //Identify tab title
    var title: String {
        switch self {
            case .posts: return "Posts"
            case .joinedForum: return "Joined Forum"
           
        }
    }
}
