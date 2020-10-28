//
//  ContentView.swift
//  Mel
//
//  Created by Patrik Tomas Chamelo on 10/26/20.
//

import SwiftUI
import UIKit






struct HomeView: View {
  @State var selectedImage: UIImage?
  var body: some View {
    NavigationView {
      VStack {
        if let image = selectedImage {
          Image(uiImage: image)
            .resizable()
            .renderingMode(.original)
        } else {
          Text("Select an image")
        }
        ImagePicker(sourceType: .photoLibrary) { (image) in
          self.selectedImage = image
        }
        .navigationBarItems(trailing: NavigationLink("Next", destination: Text("detail")))
      }      
    }
  }
}

public struct ImagePicker: UIViewControllerRepresentable {
  
  private let sourceType: UIImagePickerController.SourceType
  private let onImagePicked: (UIImage) -> Void
  @Environment(\.presentationMode) private var presentationMode
  
  public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
    self.sourceType = sourceType
    self.onImagePicked = onImagePicked
  }
  
  public func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = self.sourceType
    picker.delegate = context.coordinator
    return picker
  }
  
  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(
      onDismiss: { self.presentationMode.wrappedValue.dismiss() },
      onImagePicked: self.onImagePicked
    )
  }
  
  final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let onDismiss: () -> Void
    private let onImagePicked: (UIImage) -> Void
    
    init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
      self.onDismiss = onDismiss
      self.onImagePicked = onImagePicked
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let image = info[.originalImage] as? UIImage {
        self.onImagePicked(image)
      }
      self.onDismiss()
    }
    
    public func imagePickerControllerDidCancel(_: UIImagePickerController) {
      self.onDismiss()
    }
  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
