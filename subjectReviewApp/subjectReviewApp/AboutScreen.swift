//
//  AboutScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 10/5/2025.
//

import SwiftUI

struct AboutScreen: View {
  var body: some View {
      NavigationStack {
          VStack(alignment: .leading, spacing: 20) {
              Text("About UniViewer")
                  .font(.title)
              Text("Created by Rayan, Illias and Justin for Assignment 3")
              Text("App version 1.0.0")
          }
          .padding()
          .navigationTitle("About")
      }
  }
}

#Preview {
    AboutScreen()
}
