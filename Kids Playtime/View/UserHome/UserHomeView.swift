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
                
                // main view of the app
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
    }

    private var contentView: some View {
        VStack {
            userHeader
            statisticsSection
            chartSection
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
            if viewModel.userProfilePictureURL != nil {
                AsyncImage(url: viewModel.userProfilePictureURL) { image in
                    image.image?.resizable()
                }
                .foregroundStyle(AppColors.darkBlue)
                .clipShape(Circle())
                .frame(width: 64, height: 64)
                .aspectRatio(contentMode: .fill)
                .padding(8)
                .shadow(radius: 3)
            } else {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            if let userName = UserDefaults.standard.value(forKey: "name") as? String {
                Text("\(userName)")
                    .font(AppFonts.amikoSemiBold(withSize: 16))
                    .foregroundStyle(AppColors.darkBlue)
            } else {
                Text("User")
                    .font(AppFonts.amikoSemiBold(withSize: 16))
                    .foregroundStyle(AppColors.darkBlue)
            }
                
            Spacer()
            NavigationLink(destination: UserProfileView()) {
                Text("My Account")
                    .fontWeight(.bold)
                    .font(AppFonts.amikoRegular(withSize: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(AppColors.orange)
                    .cornerRadius(30)
                    .padding()
            }
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
            statisticValueView(title: "Minutes", value: viewModel.minutesPlayed)
            statisticValueView(title: "Games", value: viewModel.gamesPlayed)
            timeframePicker
        }
    }

    private var chartSection: some View {
        Chart {
            ForEach(Array(zip(viewModel.timeFrameData?.xValues ?? [], viewModel.timeFrameData?.yValues.map(String.init) ?? [])), id: \.0) { (xValue, yValue) in
                BarMark(
                    x: .value("Day", xValue),
                    y: .value("Minutes", Int(yValue) ?? 0)
                )
                .cornerRadius(8)
                .foregroundStyle(AppColors.lightBlue)
                .annotation {
                    Text(yValue)
                        .foregroundStyle(AppColors.darkBlue)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) {
                AxisValueLabel()
                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                AxisGridLine()
                    .foregroundStyle(Color.clear)
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) {
                AxisValueLabel()
                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                AxisGridLine()
                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
            }
        }
        .frame(height: 200)
        .padding()
    }

    private var savedGamesSection: some View {
        Text("Saved games")
            .font(AppFonts.amikoSemiBold(withSize: 24))
            .foregroundStyle(AppColors.darkBlue)
        return ScrollingCardsView(games: viewModel.games) { index in
            viewModel.isGameDialogActive = true
            viewModel.currentlySelectedGame = viewModel.games[index]
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

    private var timeframePicker: some View {
        Picker("TimeFrame", selection: $viewModel.selectedTimeFrame) {
            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                Text(timeFrame.rawValue.capitalized)
            }
        }
        .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
        .tint(AppColors.darkBlue)
        .padding()
    }
}


#Preview {
    UserHomeView()
}
