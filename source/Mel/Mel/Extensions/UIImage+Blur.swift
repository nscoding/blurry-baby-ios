//
//  UIImage+Blur.swift
//
//  Copyright © 2020 Kostas Kremizas / Patrik Tomas Chamelo. All rights reserved.
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
    return self.drawImageInRect(
      inputImage: blurredImage,
      inRect: rect.insetBy(dx: blurredRect.origin.x, dy: blurredRect.origin.y)
    )
  }
  
  private func blurImage(withRadius radius: Double) -> (UIImage, CGRect)? {
    let inputImage = CIImage(image: self)
    guard let filteredImage = inputImage?.applyingGaussianBlur(sigma: radius) else {
      return nil
    }

    let context = CIContext(options: nil)
    guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else {
      return nil
    }
    return (UIImage(cgImage: cgImage), filteredImage.extent)
  }
  
  private func getImageFromRect(rect: CGRect) -> UIImage? {
    guard let cg = self.cgImage, let partOfImage = cg.cropping(to: rect) else {
      return self
    }
    return UIImage(cgImage: partOfImage)
  }
}
