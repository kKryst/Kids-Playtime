//
//  ContentView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI
import FortuneWheel
//import FortuneWheel



struct DiscoverView: View {
    
    var repeatingScaleAnimation: Animation {
            Animation
                .bouncy(duration: 1) //.easeIn, .easyOut, .linear, etc...
                .repeatForever()
        }
    
    var repeatingRotateAnimation: Animation {
            Animation
                .linear(duration: 1) //.easeIn, .easyOut, .linear, etc...
                .repeatForever()
        }
    
    @State private var scale: CGFloat = 1.0
    
    @State private var rotation: Angle = .zero
    
    var games = ["🤫", "🤐", "🤐", "🤐", "🤐", "🤐"]
    
    @State private var animateView = false
    
    var body: some View {
        
        ZStack {
            AppColors.white.ignoresSafeArea()
            VStack {
                ZStack {
                    VStack {
                        Text("Feeling lucky?")
                            .font(AppFonts.amikoSemiBold(withSize: 32))
                            .foregroundStyle(AppColors.darkBlue)
                            .scaleEffect(scale)
                            .onAppear {
                                withAnimation(self.repeatingScaleAnimation) {self.scale = 1.1}
                            }
                        FortuneWheel(titles: games, size: 320) { index in
                            print("selected \(games[index])")
                        }
                        .padding()
                    }
                    VStack {
                        Image(systemName: "hand.draw.fill")
                            .frame(width: 64, height: 64)
                            .scaleEffect(5)
                            .foregroundStyle(AppColors.darkBlue)
                            .rotationEffect(rotation)
                            .onAppear {
                                withAnimation(self.repeatingRotateAnimation) {self.rotation = .degrees(-30 )}
                            }
                    }
                    .offset(y: 30)
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
}

//struct Pie: Shape {
//    var startAngle: Angle
//    var endAngle: Angle
//    func path(in rect: CGRect) -> Path {
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        let radius = min(rect.width, rect.height) / 2
//        let start = CGPoint(
//            x: center.x + radius * cos(CGFloat(startAngle.radians)),
//            y: center.y + radius * sin(CGFloat(startAngle.radians))
//        )
//        var path = Path()
//        path.move(to: center)
//        path.addLine(to: start)
//        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        path.addLine(to: center)
//        return path
//    }
//}
//
//struct TrianglePointer: View {
//    var body: some View {
//        Path { path in
//            path.move(to: CGPoint(x: 15, y: 0))
//            path.addLine(to: CGPoint(x: 30, y: 30))
//            path.addLine(to: CGPoint(x: 0, y: 30))
//        }
//        .fill(Color.black)
//    }
//}
//    var body: some View {
//        VStack (spacing: 8){
//            ZStack(alignment: .center) {
//                ForEach(0..<count, id: \.self) { index in
//                    Pie(startAngle: .degrees(Double(index) / Double(count) * 360), endAngle: .degrees(Double(index + 1) / Double(count) * 360))
//                        .fill(colors[index % colors.count])
//                }
//                TrianglePointer()
//                       .offset() // Adjust as needed
//                       .frame(width: 30, height: 30)
//            }
//            .background(Color.pink)
//        .rotationEffect(.degrees(spin))
//        }
//        Spacer()
//        Button {
//            if count < colors.count {
//                count += 1
//            } else {
//                count = 0
//            }
//        } label: {
//            Text("Add Color")
//        }
//        Button {
//            withAnimation(.spring(response: 3, dampingFraction: 1)) {
//                let randomMultiplier = Double(Int.random(in: 5...10))
//                let randomValue = Double(Int.random(in: 180...360))
//                spin += randomMultiplier * randomValue
//            }
//        } label: {
//            Text("Spin")
//        }
//
//    }
