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
                    self.delegate?.downloadFailed()
                    return
                }
                imageCache.setObject(imageToCache, forKey: urlStr as AnyObject)
                self.img = UIImage(data: data)
                if let i = self.img {
                    print("Successfully downloaded")
                    self.delegate?.downloadFinishWith(image: i)
                } else {
                    self.delegate?.downloadFailed()
                }
            case .failure(_):
                self.delegate?.downloadFailed()
                break
            }
        }
    }
}
