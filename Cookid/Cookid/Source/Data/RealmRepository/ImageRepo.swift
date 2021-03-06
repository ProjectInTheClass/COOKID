//
//  ImageRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/03.
//

import UIKit

protocol FileManagerRepoType {
    func saveImage(image: UIImage, id: String, completion: @escaping (Bool) -> Void)
    func loadImage(id: String) -> UIImage?
    func deleteImage(id: String, completion: @escaping (Bool) -> Void)
}

class FileManagerRepo: BaseRepository, FileManagerRepoType {
    
    func saveImage(image: UIImage, id: String, completion: @escaping (Bool) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            print("-----> Can't convert Image to jpeg")
            return completion(false) }
       
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveURL = directory.appendingPathComponent(id)
            do {
                try data.write(to: archiveURL)
                completion(true)
            } catch let error {
                print(error)
                completion(false)
            }
        } else {
            print("-----> directory not found")
        }
    }
    
    func loadImage(id: String) -> UIImage? {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveURL = directory.appendingPathComponent(id)
            do {
                let data = try Data(contentsOf: archiveURL)
                let image = UIImage(data: data)
                return image
            } catch {
                print(error)
                return nil
            }
        } else {
            print("-----> directory not found")
            return nil
        }
    }
    
    func deleteImage(id: String, completion: @escaping (Bool) -> Void) {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let fileIDs = try FileManager.default.contentsOfDirectory(atPath: directory.path)
                for fileID in fileIDs where fileID == id {
                    let filePath = directory.appendingPathComponent(fileID).path
                    try FileManager.default.removeItem(atPath: filePath)
                    completion(true)
                    return
                }
            } catch let error {
                print("-----> fileID not found")
                print(error)
                completion(false)
            }
        } else {
            print("-----> directory not found")
            completion(false)
        }
    }
    
}
