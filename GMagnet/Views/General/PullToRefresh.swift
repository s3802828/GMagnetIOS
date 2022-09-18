/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 11/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
  Pull down to refresh data in SwiftUI - https://stackoverflow.com/questions/56493660/pull-down-to-refresh-data-in-swiftui/65100922#65100922
*/

import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        //Identify the position to start refresh
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                //if position is out of view larger than 50, start refreshing
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                //the position return normal, done refreshing, call refresh function
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    //currently refreshing
                    ProgressView()
                } else {
                    //hasn't refreshed
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

