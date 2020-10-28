//
//  PhotoLibrary.swift
//
//  Copyright © 2020 Kostas Kremizas / Patrik Tomas Chamelo. All rights reserved.
//

import Foundation
import SwiftUI

class PhotoLibrary {
    func writeToPhotoAlbum(image: UIImage) {
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
      print("Save finished!")
    }
}
