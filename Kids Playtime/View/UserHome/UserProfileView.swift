//
//  UserProfileView.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 05/02/2024.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import CachedAsyncImage

enum Gender: String, CaseIterable, Identifiable {
    case male, female, other
    var id: Self { self }
}

struct UserProfileView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var userEmail = ""
    @State private var userName = ""
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    @State private var selectedGender: Gender = .male
    
    @State private var userProfileImageURL: String? = nil
    
    @FocusState private var isFirstResponder :Bool
    
    @Environment(\.dismiss) private var dismiss
    
#warning("sprawdz co sie dzieje jak wybierasz zdjecia po dodaniu juz jednego jako ten user")
    
    
    init() {
        //style the Picker
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(AppColors.orange.opacity(0.7))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(AppColors.darkBlue)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(AppColors.darkBlue)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(AppColors.orange.opacity(0.1))
    }
    
    var body: some View {
        ZStack {
            AppColors.white.ignoresSafeArea()
                .onTapGesture {
                    // defocus text fields when clicking on the screen
                    isFirstResponder = false
                }
            VStack {
                HStack {
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                            .aspectRatio(contentMode: .fit)
                            .padding(8)
                            .shadow(radius: 3)
                    }
                    else if let userProfileImageURL = userProfileImageURL {
                        CachedAsyncImage(url: URL(string:userProfileImageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 64, height: 64)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 64, height: 64)
                                    .padding(8)
                                    .shadow(radius: 3)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 64, height: 64)
                                    .padding(8)
                                    .shadow(radius: 3)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        ProgressView()
                            .frame(width: 64, height: 64)
                    }
                    VStack {
                        if let userName = UserDefaults.standard.value(forKey: "name") as? String {
                            Text("\(userName)")
                                .font(AppFonts.amikoSemiBold(withSize: 24))
                                .foregroundStyle(AppColors.darkBlue)
                        } else {
                            Text("User")
                                .font(AppFonts.amikoSemiBold(withSize: 24))
                                .foregroundStyle(AppColors.darkBlue)
                        }
                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            Label("Select a picture", systemImage: "photo")
                                .foregroundStyle(AppColors.darkBlue)
                                .font(AppFonts.amikoSemiBold(withSize: 16))
                        }
                    }
                    .onChange(of: pickerItem, perform: { value in
                        Task {
                            if let pickerItem {
                                // Load image data
                                if let imageData = try? await pickerItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: imageData) {
                                    selectedImage = Image(uiImage: uiImage)
                                    if let userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String {
                                        let filename = StorageManager.getFileName(for: userEmail)
                                        StorageManager.shared.uploadProfilePicture(with: imageData, fileName: filename) { result in
                                            switch result {
                                            case .success:
                                                print("")
                                            case .failure(let error):
                                                print("Storage manager error: \(error)")
                                            }
                                        }
                                    } else {
                                        print("Error retrieving user email from UserDefaults")
                                    }
                                } else {
                                    print("Error loading image data or converting to UIImage")
                                }
                            }
                        }
                    })
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 20, style: .circular).foregroundStyle(AppColors.orange).opacity(0.1))
                .task {
                    if userProfileImageURL == nil {
                        getUserProfilePictureURL()
                    }
                }
                
                HStack {
                    Text("Email")
                        .font(AppFonts.amikoRegular(withSize: 18))
                        .foregroundStyle(AppColors.darkBlue)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextField("Email", text: $userEmail)
                    .font(AppFonts.amikoRegular(withSize: 24))
                    .focused($isFirstResponder)
                    .cornerRadius(20)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.darkBlue, lineWidth: 1)
                    }
                    .padding(.horizontal)
                
                HStack {
                    Text("Username")
                        .font(AppFonts.amikoRegular(withSize: 18))
                        .foregroundStyle(AppColors.darkBlue)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextField("Username", text: $userName)
                    .focused($isFirstResponder)
                    .font(AppFonts.amikoRegular(withSize: 24))
                    .cornerRadius(20)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.darkBlue, lineWidth: 1)
                    }
                    .padding(.horizontal)
                
                HStack {
                    Text("Gender")
                        .font(AppFonts.amikoRegular(withSize: 16))
                        .foregroundStyle(AppColors.darkBlue)
                    
                    Picker("TimeFrame", selection: $selectedGender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized)
                                .font(AppFonts.amikoSemiBold(withSize: 16))
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(AppColors.darkBlue)
                    .padding()
                }
                .padding()
                
                Button(action: {
                    AuthManager.shared.logoutUser()
                    dismiss()
                }, label: {
                    Text("Logout")
                        .fontWeight(.bold)
                        .font(AppFonts.amikoRegular(withSize: 16))
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.orange, lineWidth: 1)
                        )
                })
                .padding(.vertical, 5)
                .padding(.horizontal)
                
                Button(action: {
                    // Action for deleting account
                }, label: {
                    Text("Delete account")
                        .fontWeight(.bold)
                        .font(AppFonts.amikoRegular(withSize: 16))
                        .foregroundColor(AppColors.white) // Set the text color to white
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.orange) // Set the background color to dark blue
                        .cornerRadius(12) // Set the corner radius for rounded corners
                })
                .padding(.horizontal)
            }
            .onAppear {
                viewRouter.shouldDisplayTabView = false
            }
            .onDisappear(perform: {
                viewRouter.shouldDisplayTabView = true
            })
        }
    }
    
    private func getUserProfilePictureURL() {
        /*
         /images/emailaddress123-gmail-com_profile_picture.png
         */
        if let loggedInUserEmail = UserDefaults.standard.value(forKey: "userEmail") as? String {
            let pathToImage = StorageManager.getPathToImage(for: loggedInUserEmail)
            StorageManager.shared.downloadURL(for: pathToImage) { result in
                switch result {
                case .success(let url):
                    userProfileImageURL = url.absoluteString
                case .failure(let error):
                    print("failed to get img url: \(error)")
                }
            }
        } else {
            print("No userEmail in cache")
        }
    }
}

#Preview {
    UserProfileView()
        .environmentObject(ViewRouter())
}
