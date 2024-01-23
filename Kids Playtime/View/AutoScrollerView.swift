//
//  AutoScroller.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 21/01/2024.
//

import SwiftUI

struct AutoScrollerView: View {
    var imageNames: [String]
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var seconds = 0
    var onTapGesture: () -> Void
    
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
                                        .onTapGesture {
                                            onTapGesture()
                                        }
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("Name of the game").font(AppFonts.amikoSemiBold(withSize: 24)).foregroundStyle(AppColors.darkBlue)
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


#Preview {
    AutoScrollerView(imageNames: ["imag", "imag", "imag"], onTapGesture:{})
}
