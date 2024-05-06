//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import Charts

    struct UserHomeView: View {
        
        //TODO: 05.05 zaprogramowac chart aby reagowal na zmiane timeFrame
        
        @EnvironmentObject var viewRouter: ViewRouter
        
        @StateObject private var viewModel = ViewModel()
        
        var body: some View {
            NavigationStack {
                ZStack {
                    AppColors.white.ignoresSafeArea()
                    ScrollView {
                        VStack {
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
                                NavigationLink {
                                    UserProfileView()
                                } label: {
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
                            .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
                            
                            HStack(alignment: .top) {
                                VStack {
                                    TextIncreasingValue(endValue: viewModel.minutesPlayed, duration: 1)
                                        .font(AppFonts.amikoSemiBold(withSize: 28))
                                        .foregroundStyle(AppColors.darkBlue)
                                        .onChange(of: viewModel.selectedTimeFrame) { newValue in
                                            viewModel.calculateGamesPlayedPerWeek()
                                        }
                                    Text("Minutes")
                                        .font(AppFonts.amikoRegular(withSize: 14))
                                        .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.horizontal)
                                VStack {
                                    TextIncreasingValue(endValue: viewModel.gamesPlayed, duration: 1)
                                        .font(AppFonts.amikoSemiBold(withSize: 28))
                                        .foregroundStyle(AppColors.darkBlue)
                                        .onChange(of: viewModel.selectedTimeFrame) { newValue in
                                            viewModel.calculateMinutesPlayedPerWeek()
                                        }
                                    Text("Games")
                                        .font(AppFonts.amikoRegular(withSize: 14))
                                        .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                }
                                .padding(.horizontal)
                                Spacer()
                                Picker("TimeFrame", selection: $viewModel.selectedTimeFrame) {
                                    ForEach(TimeFrame.allCases) { timeFrame in
                                        Text(timeFrame.rawValue.capitalized)
                                    }
                                }
                                .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
                                .tint(AppColors.darkBlue)
                                .padding()
                            }
                            .padding()
                            
                            Chart(viewModel.data) { d in
                                BarMark(
                                    x: PlottableValue.value("Day", d.day),
                                    y: PlottableValue.value("Minutes", d.minutesPlayed)
                                )
                                .cornerRadius(8)
                                .foregroundStyle(AppColors.lightBlue)
                                .annotation{
                                    Text("\(d.minutesPlayed)")
                                        .foregroundStyle(AppColors.darkBlue)
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
                            
                            Divider()
                            
                            Text("Saved games")
                                .font(AppFonts.amikoSemiBold(withSize: 24))
                                .foregroundStyle(AppColors.darkBlue)
                            ScrollingCardsView(gameCards: viewModel.games) { index in
                                viewModel.isGameDialogActive = true
                                viewModel.currentlySelectedGame = viewModel.games[index]
                            }
                            
                            Spacer()
                        }
                        .padding()
                        Rectangle()
                            .frame(height:20)
                            .padding(20)
                            .background(Color.clear)
                            .foregroundStyle(Color.clear)
                    }
                    if viewModel.isGameDialogActive && viewModel.currentlySelectedGame != nil{ // pops off when a game is selected
                        GameDialogView(
                            gameCard: viewModel.currentlySelectedGame!,
                            isActive: $viewModel.isGameDialogActive
                        )
                    }
                }
            }
            .tint(AppColors.darkBlue)
        }
    }

    #Preview {
        UserHomeView()
    }
