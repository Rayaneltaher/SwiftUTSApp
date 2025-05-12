//
//  RegisterScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 7/5/2025.
//

import SwiftUI

import FirebaseAuth
import FirebaseFirestore

struct RegisterScreen: View {
  @Binding var currentScreen: AppScreen

  @State private var name: String = ""
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var studentID: String = ""
  @State private var degreeName: String = ""

  @State private var showError = false
  @State private var errorMsg = ""

  var isValid: Bool {
      !name.isEmpty &&
      !email.isEmpty &&
      !password.isEmpty &&
      !studentID.isEmpty &&
      !degreeName.isEmpty
  }

  var body: some View {
    VStack {
      VStack(spacing: 10) {
        Text("Register")
          .font(.system(size: 50, weight: .semibold, design: .default))
        Spacer()
          .frame(height: 10)
          .clipped()
          VStack(spacing: 16) {
              TextField("Full Name", text: $name)
                  .font(.system(size: 20, weight: .regular, design: .default))
                  .padding()
                  .background(Color(UIColor.systemGray6))
                  .cornerRadius(25)
                  .autocapitalization(.words)

              TextField("Student ID", text: $studentID)
                  .font(.system(size: 20, weight: .regular, design: .default))
                  .padding()
                  .background(Color(UIColor.systemGray6))
                  .cornerRadius(25)
                  .keyboardType(.phonePad)

              TextField("Degree Name", text: $degreeName)
                  .font(.system(size: 20))
                  .padding()
                  .background(Color(UIColor.systemGray6))
                  .cornerRadius(25)
                  .autocapitalization(.words)

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
            errorMsg = "Please fill in all fields."
            showError = true
            } else if !email.contains("@") {
                errorMsg = "Please enter a valid email."
                showError = true
            } else if password.count < 6 {
                errorMsg = "Password must be at least 6 characters."
                showError = true
            } else {


          Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
              errorMsg = "Registration failed: \(error.localizedDescription)"
              showError = true
              return
            }

            guard let uid = result?.user.uid else {
              errorMsg = "User ID not found."
              showError = true
              return
            }

            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
              "name": name,
              "email": email,
              "studentID": studentID,
              "degreeName": degreeName
            ]) { error in
              if let error = error {
                errorMsg = "Failed to save user data: \(error.localizedDescription)"
                showError = true
              } else {
                currentScreen = .home
              }
            }
          }
        }}, label: {
             Text("Create account")
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
               //.disabled(!isValid)
               //.opacity(isValid ? 1 : 0.5)
           })

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
    RegisterScreen(currentScreen: .constant(.register))
}
