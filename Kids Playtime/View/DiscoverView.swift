//
//  ContentView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 14/01/2024.
//

import SwiftUI

struct DiscoverView: View {
    
    var repeatingScaleAnimation: Animation {
        Animation
            .bouncy(duration: 1) //.easeIn, .easyOut, .linear, etc...
            .repeatCount(3)
    }
    
    var repeatingRotateAnimation: Animation {
        Animation
            .linear(duration: 0.5) //.easeIn, .easyOut, .linear, etc...
            .repeatForever()
    }
    
    @State private var scale: CGFloat = 1.0
    
    @State private var rotation: Angle = .zero
    
    @State private var isWheelSpinning = false
    
    var games = ["🤫", "🤐", "🤐", "🤐", "🤐", "🤐"]
    
    let colors = [AppColors.pink, AppColors.lightBlue, AppColors.orange, AppColors.white]
    
    var body: some View {
        
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack {
                    ZStack {
                        VStack {
                            Rectangle().frame(height: 0).padding(20).background(Color.clear).foregroundStyle(Color.clear)
                            Text("Draw a game")
                                .font(AppFonts.bayonRegular(withSize: 48))
                                .foregroundStyle(AppColors.darkBlue)
                                .scaleEffect(scale)
                                .padding()
                                .onAppear {
                                    withAnimation(self.repeatingScaleAnimation) {self.scale = 1.1}
                                }
                            WheelFortune(titles: games, size: 320, onSpinEnd: { index in
                                isWheelSpinning = false
                            }, colors: colors, onSpinStart: {
                                isWheelSpinning = true
                            })
                            .padding()
                        }
                        if isWheelSpinning == false {
                            VStack {
                                Image(systemName: "hand.draw.fill")
                                    .frame(width: 64, height: 64)
                                    .scaleEffect(4)
                                    .foregroundStyle(AppColors.darkBlue)
                                    .rotationEffect(rotation)
                                    .onAppear {
                                        withAnimation(self.repeatingRotateAnimation) {self.rotation = .degrees(-30 )}
                                    }
                            }
                            .offset(y: 70)
                        }
                    }
                    
                    AutoScroller(imageNames: ["imag", "imag", "imag", "imag", "imag", "imag", "imag", "imag", "imag"])
                    Rectangle().frame(height: 20).padding(20).background(Color.clear).foregroundStyle(Color.clear)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    DiscoverView()
}

// Step 2: Define the AutoScroller View
struct AutoScroller: View {
    var imageNames: [String]
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var seconds = 0
    
    
    @State private var selectedImageIndex: Int = 0
    
    var body: some View {
        VStack {
            ZStack {
                VStack (){ // obrazek + teksty
                    Text("Games for today")
                        .font(AppFonts.bayonRegular(withSize: 30))
                        .foregroundStyle(AppColors.darkBlue)
                        .padding()
                    
                    TabView(selection: $selectedImageIndex) {
                        //Iterate Through Images
                        ForEach(0..<imageNames.count, id: \.self) { index in
                            ZStack(alignment: .center) {
                                VStack (alignment: .center){
                                    Image("\(imageNames[index])")
                                        .resizable()
                                        .tag(index)
                                        .frame(width: 300, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                        .padding()
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("Name of the game").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                        Spacer()
                                    }
                                    HStack (alignment: .top){
                                        VStack (spacing: 8){
                                            Text("Players").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                            Text("2-4").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                        }
                                        .padding()
                                        Spacer()
                                        VStack (spacing: 8){
                                            Text("Est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                            Text("30 min").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                        }
                                        .padding()
                                    }
                                    .frame(width: 300) // szerokosc HStacka
                                }
                                .onTapGesture {
                                    seconds = 0
                                    //TODO: implement broad data
                                }
                            }
                            .shadow(radius: 10) // cien obrazka
                        }
                    }
                    .onChange(of: selectedImageIndex, perform: { value in
                        seconds = 0
                        if selectedImageIndex == imageNames.count + 1 {
                            selectedImageIndex = 0
                        }
                    })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .ignoresSafeArea()
                }
                
                HStack {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        Capsule()
                            .fill( selectedImageIndex == index ? AppColors.orange : (AppColors.darkBlue.opacity(selectedImageIndex == index ? 1 : 0.33)))
                            .frame(height: 8)
                            .onTapGesture {
                                selectedImageIndex = index
                            }
                    }
                    .offset(y: 240)
                }
                .padding(.horizontal)
            }
            
        }
        .frame(height: 460)
        .onReceive(timer) { _ in
            // Step 16: Auto-Scrolling Logic
            withAnimation(.default) {
                if seconds == 4 {
                    selectedImageIndex = (selectedImageIndex + 1) % imageNames.count
                } else {
                    seconds += 1
                }
                
            }
        }
    }
}
