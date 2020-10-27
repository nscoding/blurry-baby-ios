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
  
  static func rects(for image: UIImage) -> [CGRect] {
    guard let ciImage = CIImage(image: image) else {
      return []
    }

    let faceDetector = CIDetector(ofType: CIDetectorTypeFace,
                                 context: nil,
                                 options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
    let faces = faceDetector.features(in: ciImage)
    return faces.map { $0.bounds }
  }
}

