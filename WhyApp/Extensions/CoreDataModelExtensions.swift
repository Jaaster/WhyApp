//
//  CoreDataModelExtensions.swift
//  WhyApp
//
//  Created by Joriah Lasater on 7/4/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import AVKit
import UIKit

extension Goal : XCoreDataProtocol { }
extension Note : XCoreDataProtocol { }
extension Image : XCoreDataProtocol { }
extension Video : XCoreDataProtocol { }

extension Goal {
    func relationalObjects<T: XCoreDataProtocol>(type: T) -> [T] {
        var result = [T]()
        let set: NSSet?
        
        if type is Note {
            set = self.notes
        } else if type is Video {
            set = self.videos
        } else if type is Image {
            set = self.images
        } else {
            set = NSSet()
        }
        
        set?.forEach({ (element) in
            if let element = element as? T {
                result.append(element)
            }
        })
        return result
    }
}

extension Image {
    func getUIImage() -> UIImage {
        
        guard let imageUrlPath = data else {
            return UIImage()
        }
        
        let nsDocumentDirectory = FileManager.default.temporaryDirectory
        let imageURL = nsDocumentDirectory.appendingPathComponent(imageUrlPath)
        
        if let image = UIImage(contentsOfFile: imageURL.path) {
            return image
        }
        
        return UIImage()
    }
}

extension Video {
    
    private func url() -> URL? {
        guard let videoUrlPath = data else {
            return nil
        }
        
        let nsDocumentDirectory = FileManager.default.temporaryDirectory
        
        let videoUrl = nsDocumentDirectory.appendingPathComponent(videoUrlPath)
        print("Video URL From CoreData")
        print(videoUrl)
        print("-----------------------------------")
        return videoUrl
    }
    
    func avPlayer() -> AVPlayer {
        if let url = url() {
            return AVPlayer(url: url)
        }
        return AVPlayer()
    }
    
    func thumbNailImage() -> UIImage? {
        guard let url = url() else {
            return nil
        }
        
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            //URL IS CORRECT this is not getting the correct image
            let image = UIImage(cgImage: thumbnailImage)
            return image
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
