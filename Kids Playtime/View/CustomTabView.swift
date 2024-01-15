//
//  CustomTabView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 15/01/2024.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String)]  = [
        ("house","Home"),
        ("book","Discover"),
        ("seal","Settings")
    ]
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 80)
                .foregroundStyle(AppColors.darkBlue)
            HStack {
                ForEach (0..<3) { index in
                    Button(action: {
                        tabSelection = index + 1
                    }, label: {
                        VStack (spacing: 8, content: {
                            Spacer()
                            Image(systemName: tabBarItems[index].image)
                            Text(tabBarItems[index].title).font(AppFonts.amikoSemiBold(withSize: 16))
                            
                            if index + 1 == tabSelection {
                                Capsule()
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "SelectedTabId", in:  animationNamespace)
                                    .offset(y: -2)
                            } else {
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundStyle(.clear)
                                    .offset(y: 3)
                                
                            }
                        })
                    })
                }
            }
            .foregroundStyle(AppColors.white)
            .frame(height: 80)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
        .previewLayout(.sizeThatFits)
}
