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
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
            NavigationStack {
                ZStack {
                    if networkManager.isConnected {
                        AppColors.white.ignoresSafeArea()
                        ScrollViewReader { scrollReader in
                            ScrollView {
                                VStack {
                                    VStack { // wheel and text
                                        Rectangle().frame(
                                            height: 0
                                        ).padding(20).background(Color.clear).foregroundStyle(Color.clear)
                                        
                                        Text("Spin the wheel")
                                            .font(AppFonts.bayonRegular(withSize: 48))
                                            .foregroundStyle(AppColors.darkBlue)
                                            .scaleEffect(viewModel.scale)
                                            .padding()
                                            .id(1)
                                            .task {
                                                viewModel.fetchAllGames()
                                            }
                                            .onAppear {
                                                withAnimation(self.repeatingScaleAnimation) {
                                                    viewModel.scale = 1.1
                                                }
                                            }
                                        
                                        if viewModel.gameTitles != nil && viewModel.games != nil {
                                            WheelFortune(titles: viewModel.gameTitles!, size: 320, onSpinEnd: { index in
                                                viewModel.isGameDialogActive = true
                                                viewModel.currentlySelectedGame = viewModel.games![index]
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
                                        } else {
                                            ProgressView()
                                                .frame(width: 320 ,height: 320)
                                            
                                        }
                                    }
                                    Text("Games for today")
                                        .font(AppFonts.bayonRegular(withSize: 30))
                                        .foregroundStyle(AppColors.darkBlue)
                                        .padding()
                                    
                                    // autoscroller
                                    if viewModel.games != nil {
                                        ScrollingCardsView(games: viewModel.games!)
                                        { index in
                                            viewModel.isGameDialogActive = true
                                            viewModel.currentlySelectedGame = viewModel.games![index]
                                        }
                                    } else {
                                        ProgressView()
                                            .frame(width: 320, height: 320)
                                        
                                    }
                                    
                                    // spacer to allow scrolling below TabBar
                                    Rectangle()
                                        .frame(height:35)
                                        .padding(20)
                                        .background(Color.clear)
                                        .foregroundStyle(Color.clear)
                                }
                            }
                            .onAppear {
                                scrollReader.scrollTo(1) // scrolls to top when user enters this view
                            }
                            .scrollIndicators(.hidden) // hides trailing scroll bar
                        }
                        if viewModel.isGameDialogActive && viewModel.currentlySelectedGame != nil && networkManager.isConnected { // pops off when a game is selected / drawn by the wheel
                            GameDialogView(
                                game: viewModel.currentlySelectedGame!,
                                isActive: $viewModel.isGameDialogActive
                            )
                            .onDisappear(perform: {
                                viewModel.isGameDialogActive = false // hide the dialog when user leaves this view
                            })
                            
                        }
                    } else {
                        NoInternetView()
                    }
                }
            }
        }
}

#Preview {
    DiscoverView()
}
