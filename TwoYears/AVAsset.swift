//
//  AVAsset.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/05/05.
//
import AVKit
import AVFoundation

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image, scale: 0, orientation: .right))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
