//
//  ProfileScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 10/5/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileScreen: View {
  @Binding var currentScreen: AppScreen

  @State private var name = ""
  @State private var email = ""
  @State private var studentID = ""
  @State private var degreeName = ""

  @State private var showError = false
  @State private var errorMsg = ""

  var body: some View {
      NavigationStack {
          VStack(alignment: .leading, spacing: 20) {
              Text("Name: \(name)")
              .font(.headline)
              Text("Email: \(email)")
              .font(.headline)
              Text("Student ID: \(studentID)")
              .font(.headline)
              Text("Degree: \(degreeName)")
              .font(.headline)

              Spacer()

              Button("Log Out") {
                  logout()
              }
              .font(.title3)
              .foregroundColor(.red)
              .padding()
              .frame(maxWidth: .infinity)
              .background(
                  RoundedRectangle(cornerRadius: 30)
                      .stroke(Color.red, lineWidth: 2)
              )
          }
          .padding()
          .navigationTitle("User Profile")
          .onAppear(perform: loadProfile)
          .alert("Error", isPresented: $showError) {
              Button("OK", role: .cancel) { }
          } message: {
              Text(errorMsg)
          }
      }
  }

  func loadProfile() {
      guard let uid = Auth.auth().currentUser?.uid else {
          errorMsg = "User not logged in"
          showError = true
          return
      }

      let db = Firestore.firestore()
      db.collection("users").document(uid).getDocument { snapshot, error in
          if let error = error {
              errorMsg = "Failed to load profile: \(error.localizedDescription)"
              showError = true
              return
          }

          guard let data = snapshot?.data() else { return }

          name = data["name"] as? String ?? "N/A"
          email = data["email"] as? String ?? "N/A"
          studentID = data["studentID"] as? String ?? "N/A"
          degreeName = data["degreeName"] as? String ?? "N/A"
      }
  }

  func logout() {
      do {
          try Auth.auth().signOut()
          currentScreen = .welcome
      } catch {
          errorMsg = "Failed to log out: \(error.localizedDescription)"
          showError = true
      }
  }
}

#Preview {
  ProfileScreen(currentScreen: .constant(.home))
}
