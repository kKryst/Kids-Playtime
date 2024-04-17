//
//  ViewRouter.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 26/01/2024.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var shouldDisplayTabView = true
    @Published var shouldNavigateBackTwice = false
}
