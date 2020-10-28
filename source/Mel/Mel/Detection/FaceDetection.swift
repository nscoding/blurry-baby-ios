//
//  FaceDetection.swift
//  Mel
//
//  Created by Patrik Tomas Chamelo on 10/26/20.
//

import Foundation
import CoreImage
import UIKit
import SwiftUI

enum FaceDetection {
  
  // Returns the rectangles on an image for all the faces detected
  static func rects(for image: UIImage, offset: CGFloat) -> [CGRect] {
    guard let ciImage = CIImage(image: image) else {
      return []
    }
    
    let faceDetector =
      CIDetector(ofType: CIDetectorTypeFace,
                 context: nil,
                 options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
    let faces: [CIFeature] = faceDetector.features(in: ciImage)
    return faces.map {
      convertRect(size: image.size, rect: $0.bounds)
        .inset(by: UIEdgeInsets(top: -offset, left: -offset, bottom: -offset, right: -offset))
    }
  }
  
  private static func convertRect(size: CGSize, rect: CGRect) -> CGRect {
    var rect = rect
    rect.origin.y = size.height - rect.origin.y - rect.height
    return rect
  }
}

