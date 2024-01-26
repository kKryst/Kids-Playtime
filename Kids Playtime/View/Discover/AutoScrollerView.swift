//
//  AutoScroller.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 21/01/2024.
//

import SwiftUI

// DOCUMENTATION: card and images are the same things!
struct AutoScrollerView: View {
    
    var imageNames: [String]
    // timer that allows cards to be automatically switched every X seconds
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var seconds = 0
    var onTapGesture: () -> Void
    
    @State private var selectedImageIndex: Int = 0 //holds currently displayed card's id.
    
    var body: some View {
        VStack {
            ZStack {
                VStack (){ // image + texts
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
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                        .padding()
                                        .shadow(radius: 5) // image's shadow
                                        .onTapGesture {
                                            onTapGesture()
                                        }
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("Name of the game").font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue)
                                        Spacer()
                                    }
                                    HStack (alignment: .top, spacing: 30){
                                        VStack (spacing: 8){
                                            Text("Players").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                            Text("2-4").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                        }
                                        .padding()
                                        VStack (spacing: 8){
                                            Text("Est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                            Text("30 min").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                        }
                                        .padding()
                                    }
                                }
                                // resets seconds counter when user taps on image
                                .onTapGesture {
                                    seconds = 0
                                }
                            }
                            
                        }
                    }
                    // resets timer when current card is changed by user or automatically
                    .onChange(of: selectedImageIndex, perform: { value in
                        seconds = 0
                        // when timer auto-swaps last image, go to the first one
                        if selectedImageIndex == imageNames.count + 1 {
                            selectedImageIndex = 0
                        }
                    })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .ignoresSafeArea()
                }
                // capsules below the images
                HStack {
                    ForEach(0..<imageNames.count, id: \.self) { index in
                        Capsule()
                        // paint capsule that represents currently selected card
                            .fill( selectedImageIndex == index ? AppColors.orange : (AppColors.darkBlue.opacity(selectedImageIndex == index ? 1 : 0.33)))
                            .frame(height: 8)
                            .onTapGesture { //change card when user taps on a capsule
                                withAnimation(.spring) {
                                    selectedImageIndex = index
                                }
                            }
                    } // places the capsules below the images
                    .offset(y: 240)
                }
                .padding(.horizontal)
            }   
        }
        .frame(height: 460)
        // recieved each second
        .onReceive(timer) { _ in
            withAnimation(.default) {
                if seconds == 4 {
                    selectedImageIndex = (selectedImageIndex + 1) % imageNames.count // swap card
                } else {
                    seconds += 1 // increase seconds
                }
            }
        }
    }
}


#Preview {
    AutoScrollerView(imageNames: ["imag", "imag", "imag"], onTapGesture:{})
}
