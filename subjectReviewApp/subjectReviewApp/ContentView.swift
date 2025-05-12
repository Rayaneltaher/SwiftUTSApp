//
//  ContentView.swift
//  subjectReviewApp
//
//  Created by Ilias Vasiliou on 6/5/2025.
//

import SwiftUI

struct ContentView: View {
  @Binding var currentScreen: AppScreen

  var body: some View {
      TabView {
          SubjectsScreen()
              .tabItem {
                  Label("Subjects", systemImage: "book.closed")
              }

          ProfileScreen(currentScreen: $currentScreen)
              .tabItem {
                  Label("Profile", systemImage: "person.crop.circle")
              }

          AboutScreen()
              .tabItem {
                  Label("About", systemImage: "info.circle")
              }
      }
  }
}

#Preview {
    ContentView(currentScreen: .constant(.home))
}
