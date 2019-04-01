//
//  UIImageView+NetworkCache.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  From: https://gist.github.com/wongandydev/35c4599ec8f060e8f5537e2ef86d1df0#file-uiimageview-extension-swift
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func from(urlString: String, placeholder: UIImage? = nil) {
        let url = URL(string: urlString)

        image = placeholder

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }

        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if data != nil {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
}
