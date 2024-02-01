//
//  HomeView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import Charts

enum TimeFrame: String, CaseIterable, Identifiable {
    case day, week, month, year
    var id: Self { self }
}

struct UserStatsData: Identifiable {
    var id = UUID().uuidString
    let day: String
    let minutesPlayed: Int
    let numbersOfGamesPlayed: Int
    let date: Date
    var animated: Bool = false
}

struct UserHomeView: View {
    
    @State var data = [
        UserStatsData(day: "Mon", minutesPlayed: 30, numbersOfGamesPlayed: 2, date: Date()),
        UserStatsData(day: "Tue", minutesPlayed: 40, numbersOfGamesPlayed: 1, date: Date()),
        UserStatsData(day: "Wed", minutesPlayed: 33, numbersOfGamesPlayed: 1, date: Date()),
        UserStatsData(day: "Thu", minutesPlayed: 113, numbersOfGamesPlayed: 3, date: Date()),
        UserStatsData(day: "Fri", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
        UserStatsData(day: "Sat", minutesPlayed: 0, numbersOfGamesPlayed: 0, date: Date()),
        UserStatsData(day: "Sun", minutesPlayed: 53, numbersOfGamesPlayed: 2, date: Date())
    ]
    
    @State private var minutesOfPlaying = 300
    
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var animateChart = false
    var body: some View {
        //        Text("a picker to select time frame (day / week / two weeks / month / year)")
        //        Text("Time spend playing and a goal to set (a button overlaying the circle if not set)")
        //        Text("games player - animation that goes from 0 to the actual value")
        //        Text("name of the user on top in one HStack with time frame")
        //        Text("Chart with minues spend playing each dat for of the week (to be synced with timeframe)")
        ZStack {
            AppColors.white.ignoresSafeArea()
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
                    Picker("TimeFrame", selection: $selectedTimeFrame) {
                        ForEach(TimeFrame.allCases) { timeFrame in
                            Text(timeFrame.rawValue.capitalized)
                        }
                    }
                    .tint(AppColors.orange)
                    .padding(8)
                }
                .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.lightBlue).opacity(0.1))
                
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
                            .foregroundStyle(AppColors.darkBlue)
                        
                        AxisGridLine()
                            .foregroundStyle(AppColors.darkBlue)
                    }
                }
                .frame(height: 200)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.darkBlue, lineWidth: 1)
                )
                .onAppear {
                    withAnimation(.spring()) {
                        animateChart = true // Trigger the animation
                    }
                }
                HStack(spacing: 60) {
                    VStack {
                        Text("Minutes of \n playing")
                            .font(AppFonts.amikoRegular(withSize: 14))
                            .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                            .multilineTextAlignment(.center)
                        TextIncreasingValue(endValue: minutesOfPlaying, duration: 1)
                            .font(AppFonts.amikoSemiBold(withSize: 28))
                            .foregroundStyle(AppColors.darkBlue)
                        
                    }
                    VStack {
                        Text("Games \nplayed")
                            .font(AppFonts.amikoRegular(withSize: 14))
                            .foregroundStyle(AppColors.darkBlue.opacity(0.7))
                        TextIncreasingValue(endValue: 1000, duration: 1)
                            .font(AppFonts.amikoSemiBold(withSize: 18))
                            .foregroundStyle(AppColors.darkBlue)
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    UserHomeView()
}
