//
//  ContentView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct DiscoverView: View {
    
    // animation for text and tap Icon
    var repeatingScaleAnimation: Animation {
        Animation
            .bouncy(duration: 1)
            .repeatCount(3)
    }
    
    @State private var isGameDialogActive = false
    @State private var scale: CGFloat = 1.0
    @State private var isWheelSpinning = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    #warning("will be handled by VM")
    var games = ["🤫", "🤐", "🤐", "🤐", "🤐", "🤐"]
    
    #warning("To be moved to constants")
    let colors = [AppColors.pink, AppColors.lightBlue, AppColors.orange, AppColors.white]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView {
                    VStack {
                        VStack { // wheel and text
                            Rectangle().frame(
                                height: 0
                            ).padding(20).background(Color.clear).foregroundStyle(Color.clear)
                            Text("Draw a game")
                                .font(AppFonts.bayonRegular(withSize: 48))
                                .foregroundStyle(AppColors.darkBlue)
                                .scaleEffect(scale)
                                .padding()
                                .onAppear {
                                    withAnimation(self.repeatingScaleAnimation) {
                                        self.scale = 1.1
                                    }
                                }
                            WheelFortune(titles: games, size: 320, onSpinEnd: { index in
                                isGameDialogActive = true
                            }, colors: colors, onSpinStart: {
                            })
                            .padding()
                            .overlay {
                                // adds icon on the wheel
                                VStack {
                                    Image(systemName: "hand.tap.fill")
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .scaleEffect(scale)
                                        .foregroundStyle(AppColors.darkBlue)
                                }
                                .disabled(true)
                            }
                            #warning("Small images instead of emojis")
                        }
                        // autoscroller
                        AutoScrollerView(
                            imageNames: ["imag", "imag", "imag", "imag", "imag", "imag", "imag", "imag", "imag"])
                        { //onTap for AutoScroller
                            isGameDialogActive = true
                        }
                        // spacer to allow scrolling below TabBar
                        Rectangle()
                            .frame(height:20)
                            .padding(20)
                            .background(Color.clear)
                            .foregroundStyle(Color.clear)
                    }
                }
                .scrollIndicators(.hidden) // hides trailing scroll bar
                if isGameDialogActive { // pops off when a game is selected / drawn by the wheel
                    GameDialogView(isActive: $isGameDialogActive, title: "Chosen game", players: "2-4", time: "30 min.", image: "imag")
                    
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
}
