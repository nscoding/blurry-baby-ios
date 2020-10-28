//
//  DetailView.swift
//  Mel
//
//  Created by kremyzas on 10/27/20.
//

import SwiftUI

struct DetailView: View {
  let image: UIImage
  var body: some View {
    Image(uiImage: image)
      .clipped()
      .navigationBarTitle("Detail")
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(image: UIImage(systemName: "music.note")!)
  }
}
