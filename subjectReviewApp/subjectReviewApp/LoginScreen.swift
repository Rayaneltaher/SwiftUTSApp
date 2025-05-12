//
//  LoginScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 6/5/2025.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
  @Binding var currentScreen: AppScreen

  @State private var email: String = ""
  @State private var password: String = ""

  @State private var showError = false
  @State private var errorMsg = ""

  var isValid: Bool {
      !email.isEmpty &&
      !password.isEmpty
  }

  var body: some View {
    VStack {
      VStack(spacing: 10) {
        Text("Login")
          .font(.system(size: 50, weight: .semibold, design: .default))
        Spacer()
          .frame(height: 10)
          .clipped()
          VStack(spacing: 16) {
              TextField("Email", text: $email)
                  .font(.system(size: 20, weight: .regular, design: .default))
                  .padding()
                  .background(Color(UIColor.systemGray6))
                  .cornerRadius(25)
                  .keyboardType(.emailAddress)
                  .autocapitalization(.none)
                  .textContentType(.emailAddress)

              SecureField("Password", text: $password)
                  .font(.system(size: 20, weight: .regular, design: .default))
                  .padding()
                  .background(Color(UIColor.systemGray6))
                  .cornerRadius(25)
          }

        .padding(.horizontal, 20)
        .padding(.vertical, 20)

        .clipped()
        VStack(spacing: 19) {
          Button(action: { if !isValid {
            errorMsg = "Please enter both email and password."
            showError = true
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    errorMsg = "The email or password are incorrect."
                    showError = true
                } else {
                    currentScreen = .home
                }
            }
        }
          }) {
              Text("Login")
                  .font(.system(.title, weight: .medium))
                  .frame(maxWidth: .infinity)
                  .padding()
                  .clipped()
                  .foregroundColor(.purple)
                  .frame(height: 60)
                  .background(
                      RoundedRectangle(
                          cornerRadius: 50,
                          style: .continuous
                      )
                      .stroke(.purple, lineWidth: 2)
                      .frame(width: 250)
                  )
          }

          Button(action: { currentScreen = .welcome }, label: {
             Text("Back")
               .font(.system(.title, weight: .medium))
               .frame(maxWidth: .infinity)
               .padding()
               .clipped()
               .foregroundColor(.purple)
               .frame(height: 60)
               .background(
                 RoundedRectangle(
                   cornerRadius: 50,
                   style: .continuous
                 )
                 .stroke(.purple, lineWidth: 2)
                 .frame(width: 130)
               )
           })
        }
        .padding(.horizontal, 40)
      }
      .padding(.horizontal)
    }
    .alert("Error", isPresented: $showError) {
        Button("OK", role: .cancel) { }
    } message: {
        Text(errorMsg)
    }
  }
}


#Preview {
    LoginScreen(currentScreen: .constant(.login))
}
