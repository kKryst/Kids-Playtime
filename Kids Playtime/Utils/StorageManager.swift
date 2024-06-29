//
//  StorageManager.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 29/05/2024.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /*
     /images/emailaddress123-gmail-com_profile_picture.png
     */
    
    static func getPathToImage(for email: String) -> String {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        return "/images/\(safeEmail)_profile_picture.png"
    }
    
    static func getFileName(for email: String) -> String {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        return "\(safeEmail)_profile_picture.png"
    }
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName.lowercased())").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                UserDefaults.standard.setValue(urlString, forKey: "userProfileImageURL")
                
                completion(.success(urlString))
            })
        })
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            let urlString = url.absoluteString
            UserDefaults.standard.setValue(urlString, forKey: "userProfileImageURL")
            completion(.success(url))
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
