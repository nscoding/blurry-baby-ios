//
//  UIImage+Blur.swift
//  Mel
//
//  Created by Patrik Tomas Chamelo on 10/26/20.
//

import Foundation
import CoreImage
import CoreGraphics
import UIKit
import SwiftUI

extension UIImage {
  
  func blurredImage(at rects:[CGRect], radius: Double)  -> UIImage {
    return rects.reduce(self) { ( image: UIImage, rect: CGRect) in
      return image.applyBlurInRect(rect: rect, withRadius: radius)
    }
  }
  
  private func drawImageInRect(inputImage: UIImage, inRect imageRect: CGRect) -> UIImage {
    UIGraphicsBeginImageContext(self.size)
    self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
    inputImage.draw(in: imageRect)
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return inputImage }
    UIGraphicsEndImageContext()
    return newImage
  }
  
  private func applyBlurInRect(rect: CGRect, withRadius radius: Double) -> UIImage {
    if let partOfImageAtRect = self.getImageFromRect(rect: rect),
       let blurredZone = partOfImageAtRect.blurImage(withRadius: radius) {
      return self.drawImageInRect(inputImage: blurredZone, inRect: rect)
    }
    return self
  }
  
  private func blurImage(withRadius radius: Double) -> UIImage? {
    let inputImage = CIImage(image: self)
    if let filter = CIFilter(name: "CIGaussianBlur") {
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      filter.setValue((radius), forKey: kCIInputRadiusKey)
      if let blurred = filter.outputImage {
        return UIImage.init(ciImage: blurred)
      }
    }
    return nil
  }
  
  private func getImageFromRect(rect: CGRect) -> UIImage? {
    if let cg = self.cgImage,
       let partOfImage = cg.cropping(to: rect) {
      return UIImage(cgImage: partOfImage)
    }
    return nil
  }
}
