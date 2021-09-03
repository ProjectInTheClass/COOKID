//
//  ImageRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/03.
//

import UIKit

class ImageRepo {
    static let instance = ImageRepo()
    
    func saveImage(image: UIImage, id: String, completion: @escaping (Bool)->Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return completion(false) }
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            do {
                try data.write(to: directory.appendingPathComponent(id))
                completion(true)
            } catch let error {
                completion(false)
                print(error)
            }
        }
    }
    
    func fetchImage(id: String) -> UIImage? {
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let path = URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(id).path
            let image = UIImage(contentsOfFile: path)
            return image
        } else {
            return nil
        }
    }
    
    func deleteImage(id: String, completion: @escaping (Bool)->Void) {
        if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            do {
                let fileIDs = try FileManager.default.contentsOfDirectory(atPath: directory.path)
                for fileID in fileIDs {
                    if fileID == id {
                        let filePath = "\(directory.path)\(fileID)"
                        try FileManager.default.removeItem(atPath: filePath)
                        completion(true)
                        return
                    }
                }
            } catch let error {
                print(error)
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
}
