//
//  ContentView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct DiscoverView: View {
    
    var repeatingScaleAnimation: Animation {
        Animation
            .bouncy(duration: 1)
            .repeatCount(3)
    }
    
    var repeatingRotateAnimation: Animation {
        Animation
            .linear(duration: 0.5)
            .repeatForever()
    }
    
    @State private var isGameDialogActive = false
    
    @State private var scale: CGFloat = 1.0
    
    @State private var rotation: Angle = .zero
    
    @State private var isWheelSpinning = false
    
    var games = ["🤫", "🤐", "🤐", "🤐", "🤐", "🤐"]
    
    let colors = [AppColors.pink, AppColors.lightBlue, AppColors.orange, AppColors.white]
    
    var body: some View {
        
        #warning("fix bug with the GameDialogView not always appearing on the screen (probably something with offset not changing OR animation not playing")
        
        NavigationView {
            ZStack {
                AppColors.background.ignoresSafeArea()
                ScrollView {
                    VStack {
                        ZStack {
                            VStack {
                                Rectangle().frame(height: 0).padding(20).background(Color.clear).foregroundStyle(Color.clear)
                                Text("Draw a game")
                                    .font(AppFonts.bayonRegular(withSize: 48))
                                    .foregroundStyle(AppColors.darkBlue)
                                    .scaleEffect(scale)
                                    .padding()
                                    .onAppear {
                                        withAnimation(self.repeatingScaleAnimation) {self.scale = 1.1}
                                    }
                                WheelFortune(titles: games, size: 320, onSpinEnd: { index in
                                    isWheelSpinning = false
                                    isGameDialogActive = true
                                    
                                }, colors: colors, onSpinStart: {
                                    isWheelSpinning = true
                                })
                                .padding()
                                //TODO: Small images instead of emojis
                            }
                            if isWheelSpinning == false {
                                VStack {
                                    Image(systemName: "hand.draw.fill")
                                        .frame(width: 64, height: 64)
                                        .scaleEffect(4)
                                        .foregroundStyle(AppColors.darkBlue)
                                        .rotationEffect(rotation)
                                        .onAppear {
                                            withAnimation(self.repeatingRotateAnimation) {self.rotation = .degrees(-30 )}
                                        }
                                }
                                .offset(y: 70)
                            }
                        }
                        AutoScrollerView(
                            imageNames: ["imag", "imag", "imag", "imag", "imag", "imag", "imag", "imag", "imag"])
                        {
                            isGameDialogActive = true
                        }
                        Rectangle().frame(height: 20).padding(20).background(Color.clear).foregroundStyle(Color.clear)
                    }
                }
                .scrollIndicators(.hidden)
                
                if isGameDialogActive {
                        GameDialogView(isActive: $isGameDialogActive, title: "Chosen game", players: "2-4", time: "30 min.", image: "imag")
                        
                }
                
            }
        }
    }
}

#Preview {
    DiscoverView()
}
