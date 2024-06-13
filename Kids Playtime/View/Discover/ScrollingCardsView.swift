//
//  AutoScroller.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 21/01/2024.
//

import SwiftUI
import CachedAsyncImage

// DOCUMENTATION: card and images are the same things!
struct ScrollingCardsView: View { // find a better name for that
    
    // timer that allows cards to be automatically switched every X seconds
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var seconds = 0
    let games: [Game]
    let onTapGesture: (Int) -> Void
    @State private var isImageLoading = true
    
    @State private var selectedImageIndex: Int = 0 //holds currently displayed card's id.
    
    var body: some View {
        VStack {
            ZStack {
                VStack { // image + texts
                    TabView(selection: $selectedImageIndex) {
                        //Iterate Through Images
                        ForEach(0..<games.count, id: \.self) { index in
                            ZStack(alignment: .center) {
                                VStack (alignment: .center){
                                    AsyncImage(url: URL(string: "\(games[index].imageURL)")) { image in
                                        image.resizable() // Makes the image resizable, cached automatically
                                            .onAppear {
                                                isImageLoading = false
                                            }
                                        
                                    } placeholder: {
                                        ProgressView() // Placeholder while the image is loading
                                            .onAppear {
                                                isImageLoading = true
                                            }
                                    }
                                    .tag(index)
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                    .padding()
                                    .shadow(radius: 5) // image's shadow
                                    .onTapGesture {
                                        onTapGesture(index)
                                    }
                                    
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("\(games[index].title)").font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue)
                                        Spacer()
                                    }
                                    HStack (alignment: .top, spacing: 30){
                                        VStack (spacing: 8){
                                            Text("Players").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                            Text("\(games[index].minNumberOfPlayers)-\(games[index].maxNumberOfPlayers)").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
                                        }
                                        .padding()
                                        VStack (spacing: 8){
                                            Text("Est. time").font(AppFonts.amikoSemiBold(withSize: 18)).foregroundStyle(AppColors.darkBlue)
                                            Text("\(games[index].estimatedTime) min").font(AppFonts.amikoRegular(withSize: 16)).foregroundStyle(AppColors.darkBlue.opacity(0.7))
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
                        if selectedImageIndex == games.count + 1 {
                            selectedImageIndex = 0
                        }
                    })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .ignoresSafeArea()
                }
                // capsules below the images
                HStack {
                    ForEach(0..<games.count, id: \.self) { index in
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
                    .offset(y: 200)
                }
                .padding(.horizontal)
            }   
        }
        .frame(height: 380)
        // recieved each second
        .onReceive(timer) { _ in
            withAnimation(.default) {
                if seconds % 4 == 0 && seconds != 0 && !games.isEmpty && isImageLoading == false {
                    selectedImageIndex = (selectedImageIndex + 1) % games.count // swap card
                } else {
                    seconds += 1 // increase seconds
                }
            }
        }
    }
}


#Preview {
    ScrollingCardsView(games: [Game(title: "Title of game 1", imageURL: "https://cdn.britannica.com/84/73184-050-05ED59CB/Sunflower-field-Fargo-North-Dakota.jpg", minNumberOfPlayers: 3, maxNumberOfPlayers: 6, longDescription: "This is a long desc ", estimatedTime: 30)], onTapGesture:{_ in })
}
