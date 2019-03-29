//
//  UIImageView+Network.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Failed to create url \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } else {
                print("Image data is invalid")
            }
        }).resume()
    }
}
