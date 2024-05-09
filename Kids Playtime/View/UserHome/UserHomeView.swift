//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import Charts

struct UserHomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.white.ignoresSafeArea()
                ScrollView {
                    // main view of the app
                    contentView
                }
                if viewModel.isGameDialogActive && viewModel.currentlySelectedGame != nil { //game dialog which appears when user taps on a game card
                    GameDialogView(
                        gameCard: viewModel.currentlySelectedGame!,
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
            Image(systemName: "person.circle")
                .resizable()
                .foregroundStyle(AppColors.darkBlue)
                .clipShape(Circle())
                .frame(width: 64, height: 64)
                .aspectRatio(contentMode: .fill)
                .padding(8)
                .shadow(radius: 3)
            Text("Guest")
                .font(AppFonts.amikoSemiBold(withSize: 16))
                .foregroundStyle(AppColors.darkBlue)
            Spacer()
            NavigationLink(destination: UserProfileView()) {
                Text("Login")
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
        return ScrollingCardsView(gameCards: viewModel.games) { index in
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
