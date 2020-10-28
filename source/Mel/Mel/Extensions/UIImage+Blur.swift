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
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
    self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
    inputImage.draw(in: imageRect)
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return inputImage }
    UIGraphicsEndImageContext()
    return newImage
  }
  
  private func applyBlurInRect(rect: CGRect, withRadius radius: Double) -> UIImage {
    guard let partOfImageAtRect = self.getImageFromRect(rect: rect) else {
      return self
    }
    guard let (blurredImage, blurredRect) = partOfImageAtRect.blurImage(withRadius: radius) else {
      return self
    }
    return self.drawImageInRect(inputImage: blurredImage,
                                inRect: rect.insetBy(dx: blurredRect.origin.x, dy: blurredRect.origin.y))
  }
  
  private func blurImage(withRadius radius: Double) -> (UIImage, CGRect)? {
    let inputImage = CIImage(image: self)
    if let filteredImage = inputImage?.applyingGaussianBlur(sigma: radius) {
      let context = CIContext(options: nil)
      if let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) {
        return (UIImage(cgImage: cgImage), filteredImage.extent)
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
