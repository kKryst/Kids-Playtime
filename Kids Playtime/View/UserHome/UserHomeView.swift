//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import Charts

struct UserHomeView: View {
    
    @State var data = [
        UserStatsData(day: "Mon", minutesPlayed: 30, numbersOfGamesPlayed: 2, date: Date()),
        UserStatsData(day: "Tue", minutesPlayed: 40, numbersOfGamesPlayed: 1, date: Date()),
        UserStatsData(day: "Wed", minutesPlayed: 33, numbersOfGamesPlayed: 1, date: Date()),
        UserStatsData(day: "Thu", minutesPlayed: 90, numbersOfGamesPlayed: 3, date: Date()),
        UserStatsData(day: "Fri", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
        UserStatsData(day: "Sat", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
        UserStatsData(day: "Sun", minutesPlayed: 53, numbersOfGamesPlayed: 2, date: Date())
    ]
    
    @State private var minutesPlayed = 312
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var animateChart = false
    @State private var isGameDialogActive = false
    var body: some View {
        //        Text("a picker to select time frame (day / week / two weeks / month / year)")
        //        Text("Time spend playing and a goal to set (a button overlaying the circle if not set)")
        //        Text("games player - animation that goes from 0 to the actual value")
        //        Text("name of the user on top in one HStack with time frame")
        //        Text("Chart with minues spend playing each day for of the week (to be synced with timeframe)")
        NavigationStack {
            ZStack {
                AppColors.white.ignoresSafeArea()
                ScrollView {
                    VStack {
                        HStack {
                            Image("imag")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 64, height: 64)
                                .aspectRatio(contentMode: .fill)
                                .padding(8)
                                .shadow(radius: 3)
                            Text("user name")
                                .font(AppFonts.amikoSemiBold(withSize: 16))
                                .foregroundStyle(AppColors.darkBlue)
                            Spacer()
                            
                        }
                        .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
                        
                        HStack(alignment: .top) {
                            VStack {
                                
                                TextIncreasingValue(endValue: minutesPlayed, duration: 1)
                                    .font(AppFonts.amikoSemiBold(withSize: 28))
                                    .foregroundStyle(AppColors.darkBlue)
                                Text("Minutes")
                                    .font(AppFonts.amikoRegular(withSize: 14))
                                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                
                            }
                            .padding(.horizontal)
                            VStack {
                                TextIncreasingValue(endValue: 6, duration: 1)
                                    .font(AppFonts.amikoSemiBold(withSize: 28))
                                    .foregroundStyle(AppColors.darkBlue)
                                Text("Games")
                                    .font(AppFonts.amikoRegular(withSize: 14))
                                    .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                            }
                            .padding(.horizontal)
                            Spacer()
                            Picker("TimeFrame", selection: $selectedTimeFrame) {
                                ForEach(TimeFrame.allCases) { timeFrame in
                                    Text(timeFrame.rawValue.capitalized)
                                }
                            }
                            .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
                            .tint(AppColors.darkBlue)
                            .padding()
                        }
                        .padding()
                        
                        Chart(data) { d in
                            BarMark(x: .value("Day", d.day),
                                    y: .value("Minutes", animateChart ? d.minutesPlayed : 0)
                            )
                            .annotation(position: AnnotationPosition.top) {
                                Text(String(d.minutesPlayed))
                                    .foregroundStyle(AppColors.darkBlue)
                            }
                            .cornerRadius(8)
                            .foregroundStyle(AppColors.lightBlue)
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
                        .onAppear {
                            withAnimation(.spring()) {
                                animateChart = true // Trigger the animation
                            }
                        }
                        
                        Divider()
                        
                        Text("Saved games")
                            .font(AppFonts.amikoSemiBold(withSize: 24))
                            .foregroundStyle(AppColors.darkBlue)
                        AutoScrollerView(imageNames: ["imag", "imag"]) {
                            isGameDialogActive = true
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
                if isGameDialogActive { // pops off when a game is selected / drawn by the wheel
                    GameDialogView(isActive: $isGameDialogActive, title: "Chosen game", players: "2-4", time: "30 min.", image: "imag")
                    
                }
            }
        }
    }
}

#Preview {
    UserHomeView()
}
