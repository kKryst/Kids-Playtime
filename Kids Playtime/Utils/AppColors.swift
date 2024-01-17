//
//  AppColors.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct AppColors {
    // background
    static let gradientColor = Color.init(hexString: "d9e8e2")
    static let background = LinearGradient(gradient: Gradient(colors: [AppColors.white, AppColors.pink]), startPoint: .bottom, endPoint: .top)
    
    // app colors
    static let orange = Color.init(hexString: "df5431")
    static let lightBlue = Color.init(hexString: "365fed")
    static let darkBlue = Color.init(hexString: "10283f")
    static let white = Color.init(hexString: "eaf2ef")
    static let pink = Color.init(hexString: "ffadc6")
}
