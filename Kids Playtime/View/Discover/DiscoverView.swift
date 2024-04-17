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
    
    @StateObject private var viewModel = ViewModel()
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.white.ignoresSafeArea()
                ScrollView {
                    VStack {
                        VStack { // wheel and text
                            Rectangle().frame(
                                height: 0
                            ).padding(20).background(Color.clear).foregroundStyle(Color.clear)
//                            if viewModel.valueFromFirebase != nil {
//                                Text(viewModel.valueFromFirebase!)
//                                    
//                            } else {
//                                
//                            }
                            Text("Draw a game")
                                .font(AppFonts.bayonRegular(withSize: 48))
                                .foregroundStyle(AppColors.darkBlue)
                                .scaleEffect(viewModel.scale)
                                .padding()
                                .onAppear {
                                    withAnimation(self.repeatingScaleAnimation) {
                                        viewModel.scale = 1.1
                                    }
                                }
                            WheelFortune(titles: viewModel.getTitles(), size: 320, onSpinEnd: { index in
                                viewModel.isGameDialogActive = true
                                viewModel.currentlySelectedGame = viewModel.games[index]
                            }, colors: AppColors.wheelColors, onSpinStart: {
                            })
                            .padding()
                            .overlay {
                                // adds icon on the wheel
                                VStack {
                                    Image(systemName: "hand.tap.fill")
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .scaleEffect(viewModel.scale)
                                        .foregroundStyle(AppColors.darkBlue)
                                }
                            }
                        }
                        .onAppear {
                            viewModel.readValue()
                        }
                        Text("Games for today")
                            .font(AppFonts.bayonRegular(withSize: 30))
                            .foregroundStyle(AppColors.darkBlue)
                            .padding()
                        
                        // autoscroller
                        ScrollingCardsView(gameCards: viewModel.games)
                        { index in
                            viewModel.isGameDialogActive = true
                            viewModel.currentlySelectedGame = viewModel.games[index]
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
                if viewModel.isGameDialogActive && viewModel.currentlySelectedGame != nil { // pops off when a game is selected / drawn by the wheel
                    GameDialogView(
                        gameCard: viewModel.currentlySelectedGame!, 
                        isActive: $viewModel.isGameDialogActive
                    )
                    
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
}
