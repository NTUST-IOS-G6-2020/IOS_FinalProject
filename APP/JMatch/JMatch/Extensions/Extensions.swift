//
//  Extensions.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/20.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        self.image = nil
        
        // 先確認照片有沒有在暫存
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        // 沒有的話開一個cache存
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler:{(data, response, error) in
            
            if error != nil{
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
//                if let downloadImage = UIImage(data: data!) {
//                    imageCache.setObject(downloadImage, forKey: urlString)
//                    self.image = downloadImage
//                }
                self.image = UIImage(data: data!)
            })
            
        }).resume()
    }
}
