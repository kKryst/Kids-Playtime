//
//  AppFonts.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct AppFonts {

    static func amikoBold(withSize size: CGFloat) -> Font {
        return Font.custom("Amiko-Bold", size: size)
    }

    static func amikoSemiBold(withSize size: CGFloat) -> Font {
        return Font.custom("Amiko-SemiBold", size: size)
    }
    
    static func amikoRegular(withSize size: CGFloat) -> Font {
        return Font.custom("Amiko-Regular", size: size)
    }
    
    static func bayonRegular(withSize size: CGFloat) -> Font {
        return Font.custom("Bayon-Regular", size: size)
    }
}

