//
//  UIImage-extension.swift
//  TwoYears
//
//  Created by 平田翔大 on 2021/03/26.
//

import Foundation
import UIKit

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
    let widthRatio = _size.width / size.width
    let heightRatio = _size.height / size.height
    let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
    
    let resizeSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    
    UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
    draw(in: CGRect(origin: .zero, size: resizeSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage
    }
}

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

