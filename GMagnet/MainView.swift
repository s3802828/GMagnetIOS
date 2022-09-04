//
//  MainView.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach (0..<10) {
                        _ in
                        ForumCardView()
                            .padding(.vertical, 5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
