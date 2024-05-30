////
////  UserProfileViewModel.swift
////  Kids Playtime
////
////  Created by Krystian Konieczko on 29/05/2024.
////
//
//import Foundation
//import PhotosUI
//import SwiftUI
//
//extension UserProfileView {
//    
//    class ViewModel: ObservableObject {
//        @Published var userEmail = ""
//        @Published var userName = ""
//        @Published var pickerItem: PhotosPickerItem?
//        @Published var selectedImage: Image?
//        @Published var selectedGender: Gender = .male
//        @Published var userProfileImageURL: URL? = nil
//        
//        init() {
//            loadUserData()
//        }
//        
//        func loadUserData() {
//            if let email = UserDefaults.standard.value(forKey: "userEmail") as? String {
//                self.userEmail = email
//                getUserProfilePictureURL(for: email)
//            }
//            
//            if let name = UserDefaults.standard.value(forKey: "name") as? String {
//                self.userName = name
//            }
//            
//            if let genderRaw = UserDefaults.standard.value(forKey: "gender") as? String, let gender = Gender(rawValue: genderRaw) {
//                self.selectedGender = gender
//            }
//        }
//        
//        private func getUserProfilePictureURL(for email: String) {
//            let pathToImage = StorageManager.getPathToImage(for: email)
//            StorageManager.shared.downloadURL(for: pathToImage) { [weak self] result in
//                switch result {
//                case .success(let url):
//                    self?.userProfileImageURL = url
//                case .failure(let error):
//                    print("Failed to get img url: \(error)")
//                }
//            }
//        }
//    }
//}
//
//enum Gender: String, CaseIterable, Identifiable {
//    case male, female, other
//    var id: Self { self }
//}
//
