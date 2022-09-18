/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 11/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactList.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactList.swift.
*/

import SwiftUI

struct CommentList: View {
    var commentList : [Comment]
    var body: some View {
        VStack {
            if commentList.count > 0 { // if comment list has elements
                ForEach(commentList.sorted(){
                    $0.createdAt.dateValue() > $1.createdAt.dateValue()
                }, id: \.id) {
                    comment in
                    CommentRow(comment: comment)
                }
            } else {//otherwise, show this message
                Text("No comments to show")
                    .foregroundColor(GameColor().gray)
                    .font(.system(size: 20))
            }
            
        }
    }
}
