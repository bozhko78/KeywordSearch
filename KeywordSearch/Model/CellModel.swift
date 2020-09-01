//
//  Entry.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import UIKit
import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

protocol CellModelDelegate: class {
    func downloadFinishWith(image:UIImage)
    func downloadFailed()
}

class CellModel: NSObject {
    
    weak var delegate:CellModelDelegate?
    
    var title: String?
    var img: UIImage?
    var urlString: String?

    // guard multiple downloads
    var loading = false
    
    private func downsample(image: UIImage, to pointSize: CGSize, scale: CGFloat) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(image.jpegData(compressionQuality: 1.0)! as CFData, imageSourceOptions)!
     
        let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
     
        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
        
        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
     
       return UIImage(cgImage: downsampledImage)
    }

    
    func loadThumbnail() {
        guard self.img == nil else {
            return
        }
        
        guard let urlStr = self.urlString, let url = URL(string: urlStr) else { return }
        
        if let imageFromCache = imageCache.object(forKey: urlStr as AnyObject) {
            self.img = imageFromCache as? UIImage
            if let i = self.img {
                self.delegate?.downloadFinishWith(image: i)
            }
            return
        }
        
        guard !loading else {
            return
        }
        
        loading = true
        
        Networking.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            self.loading = false
            print("Download finished - \(url.lastPathComponent)")
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else {
                    self.img = UIImage(named: "downloadFailed")
                    self.delegate?.downloadFailed()
                    return
                }
                imageCache.setObject(imageToCache, forKey: urlStr as AnyObject)
                self.img = UIImage(data: data)
                if let i = self.img {
                    print("Successfully downloaded")
                    
                    self.delegate?.downloadFinishWith(image: self.downsample(image: i, to: CGSize(width: 120, height: 80), scale: 1))
                } else {
                    self.img = UIImage(named: "downloadFailed")
                    self.delegate?.downloadFailed()
                }
            case .failure(_):
                self.img = UIImage(named: "downloadFailed")
                self.delegate?.downloadFailed()
                break
            }
        }
    }
}
