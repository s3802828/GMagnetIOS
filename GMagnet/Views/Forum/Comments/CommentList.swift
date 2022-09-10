//
//  CommentList.swift
//  GMagnet
//
//  Created by Giang Le on 11/09/2022.
//

import SwiftUI

struct CommentList: View {
    var commentList : [Comment]
    var body: some View {
        VStack {
            ForEach(commentList, id: \.id) {
                comment in
                CommentRow(comment: comment)
            }
        }
    }
}
