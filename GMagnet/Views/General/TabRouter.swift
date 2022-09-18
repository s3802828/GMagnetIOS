/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 03/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
  How To Create A Custom Tab Bar In SwiftUI: https://blckbirds.com/post/custom-tab-bar-in-swiftui/
*/

import Foundation

class TabBarRouter: ObservableObject {
    //current tab page
    @Published var currentPage: Page = .home
}
