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
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.white.ignoresSafeArea()
                
                // main view
                if viewModel.isUserLoggedIn {
                    ScrollView {
                        contentView
                    }
                } else {
                    LoginView()
                }
                if viewModel.isGameDialogActive && viewModel.currentlySelectedGame != nil { //game dialog which appears when user taps on a game card
                    GameDialogView(
                        game: viewModel.currentlySelectedGame!,
                        isActive: $viewModel.isGameDialogActive
                    )
                }
            }
            .tint(AppColors.darkBlue)
        }
        .tint(AppColors.darkBlue)
    }
    
    private var contentView: some View {
        VStack {
            userHeader
            statisticsSection
                .task {
                    viewModel.getTimePlayed()
                    viewModel.getGamesPlayed()
                }
            //            chartSection
            savedGamesSection
                .task {
                    viewModel.fetchSavedGames()
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
            NavigationLink(destination: UserProfileView()) {
                userProfilePicture(url: viewModel.userProfilePictureURL)
            }
            if let userName = UserDefaults.standard.value(forKey: "name") as? String {
                Text("\(userName)")
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
            } else {
                Text("User")
                    .font(AppFonts.amikoSemiBold(withSize: 18))
                    .foregroundStyle(AppColors.darkBlue)
            }
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 20, style: .circular).fill(AppColors.lightBlue.opacity(0.1)))
        .padding(.horizontal, -10)
        .task {
            if viewModel.userProfilePictureURL == nil {
                viewModel.getUserProfilePictureURL()
            }
        }
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
                CachedAsyncImage(url: url) { phase in
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
                        Image(systemName: "photo")
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
                ProgressView()
                    .frame(width: 64, height: 64)
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
