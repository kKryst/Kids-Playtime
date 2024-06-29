//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import Charts
import FirebaseAuth
import CachedAsyncImage

struct UserHomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.white.ignoresSafeArea()
                // main view
                if networkManager.isConnected {
                    ScrollView {
                        contentView
                    }
                } else {
                    NoInternetView()
                }
                
                if viewModel.isGameDialogActive && viewModel.currentlySelectedGame != nil && networkManager.isConnected { //game dialog which appears when user taps on a game card
                    GameDialogView(
                        game: viewModel.currentlySelectedGame!, //checked for null in if statement
                        isActive: $viewModel.isGameDialogActive
                    )
                    .onDisappear(perform: {
                        viewModel.isGameDialogActive = false // hide the dialog when user leaves this view
                    })
                }
            }
            .onAppear(perform: {
                viewRouter.shouldDisplayTabView = true
            })
            .tint(AppColors.darkBlue)
        }
        .tint(AppColors.darkBlue)
    }
    
    private var contentView: some View {
        VStack {
            userHeader
            VStack {
                if viewModel.isUserLoggedIn {
                    statisticsSection
                    .task {
                        viewModel.getTimePlayed()
                        viewModel.getGamesPlayed()
                }
                } else {
                    statisticsSection
                        .onAppear(perform: {
                            viewModel.gamesPlayed = 0
                            viewModel.minutesPlayed = 0
                        })
                }
            }
            //            chartSection
            if viewModel.isUserLoggedIn {
                savedGamesSection
                    .task {
                        viewModel.fetchSavedGames()
                }
            } else {
                VStack {
                    Text("Log in to see your saved games")
                        .font(AppFonts.amikoSemiBold(withSize: 16))
                    .foregroundStyle(AppColors.darkBlue)
                    NavigationLink(destination: LoginView().accentColor(AppColors.white)) {
                        Text("Log in")
                            .fontWeight(.bold)
                            .font(AppFonts.amikoRegular(withSize: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.lightBlue)
                            .cornerRadius(12)
                    }
                    
                }
            }
            Rectangle() // bottom spacer to allow scrolling past tabBar
                .frame(height: 20)
                .padding(20)
                .background(Color.clear)
                .foregroundStyle(Color.clear)
        }
        .padding()
    }
    
    private var userHeader: some View {
        HStack {
            if viewModel.isUserLoggedIn {
                NavigationLink(destination: UserProfileView()) {
                    userProfilePicture(url: viewModel.userProfilePictureURL)
                        .task {
                            viewModel.getUserProfilePictureURL()
                        }
                }
            } else {
                NavigationLink(destination: LoginView()) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 64, height: 64)
                        .padding(8)
                        .shadow(radius: 3)
                }
            }
            if viewModel.isUserLoggedIn {
                Text(viewModel.userName)
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
                    .task {
                        viewModel.getUserName()
                    }
            } else {
                Text("User")
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
            }
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 20, style: .circular).fill(AppColors.lightBlue.opacity(0.1)))
        .padding(.horizontal, -10)
    }
    
    private var statisticsSection: some View {
        HStack(alignment: .top) {
            statisticValueView(title: "Minutes played", value: viewModel.minutesPlayed)
            statisticValueView(title: "Games played", value: viewModel.gamesPlayed)
        }
        .padding()
    }
    
    //
    
    private var savedGamesSection: some View {
        return VStack {
            Text("Saved games")
                .font(AppFonts.amikoSemiBold(withSize: 24))
                .foregroundStyle(AppColors.darkBlue)
            ScrollingCardsView(games: viewModel.games) { index in
                viewModel.isGameDialogActive = true
                viewModel.currentlySelectedGame = viewModel.games[index]
            }
        }
    }
    
    private func statisticValueView(title: String, value: Int) -> some View {
        VStack {
            TextIncreasingValue(endValue: value, duration: 1)
                .font(AppFonts.amikoSemiBold(withSize: 28))
                .foregroundStyle(AppColors.darkBlue)
            Text(title)
                .font(AppFonts.amikoRegular(withSize: 14))
                .foregroundStyle(AppColors.darkBlue.opacity(0.7))
        }
        .padding(.horizontal)
    }
    
    private func userProfilePicture(url: URL?) -> some View {
        if let url = url {
            return AnyView(
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 64, height: 64)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                            .padding(8)
                            .shadow(radius: 3)
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                            .padding(8)
                            .shadow(radius: 3)
                    @unknown default:
                        EmptyView()
                    }
                }
            )
        } else {
            return AnyView(
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 64, height: 64)
                    .padding(8)
                    .shadow(radius: 3)
            )
        }
    }

}
//    private var timeframePicker: some View {
//        Picker("TimeFrame", selection: $viewModel.selectedTimeFrame) {
//            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
//                Text(timeFrame.rawValue.capitalized)
//            }
//        }
//        .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
//        .tint(AppColors.darkBlue)
//        .padding()
//    }

//    private var chartSection: some View {
//        Chart {
//            ForEach(Array(zip(viewModel.timeFrameData?.xValues ?? [], viewModel.timeFrameData?.yValues.map(String.init) ?? [])), id: \.0) { (xValue, yValue) in
//                BarMark(
//                    x: .value("Day", xValue),
//                    y: .value("Minutes", Int(yValue) ?? 0)
//                )
//                .cornerRadius(8)
//                .foregroundStyle(AppColors.lightBlue)
//                .annotation {
//                    Text(yValue)
//                        .foregroundStyle(AppColors.darkBlue)
//                }
//            }
//        }
//        .chartXAxis {
//            AxisMarks(values: .automatic) {
//                AxisValueLabel()
//                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
//                AxisGridLine()
//                    .foregroundStyle(Color.clear)
//            }
//        }
//        .chartYAxis {
//            AxisMarks(values: .automatic) {
//                AxisValueLabel()
//                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
//                AxisGridLine()
//                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
//            }
//        }
//        .frame(height: 200)
//        .padding()
//    }



#Preview {
    UserHomeView()
}
