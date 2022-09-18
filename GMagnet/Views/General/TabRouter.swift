//
//  TabRouter.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import Foundation

class TabBarRouter: ObservableObject {
    //current tab page
    @Published var currentPage: Page = .home
}
