//
//  subjectReviewAppApp.swift
//  subjectReviewApp
//
//  Created by Ilias Vasiliou on 6/5/2025.
//

import SwiftUI
import Firebase

@main
struct subjectReviewAppApp: App {
  @State private var currentScreen: AppScreen = .welcome

  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      switch currentScreen {
      case .welcome:
        WelcomeScreen(currentScreen: $currentScreen)
      case .login:
        LoginScreen(currentScreen: $currentScreen)
      case .register:
        RegisterScreen(currentScreen: $currentScreen)
      case .home:
        ContentView(currentScreen: $currentScreen)
      }
    }
  }
}
