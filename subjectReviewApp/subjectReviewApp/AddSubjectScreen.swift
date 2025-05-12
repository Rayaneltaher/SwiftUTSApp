//
//  AddSubjectScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 10/5/2025.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct AddSubjectScreen: View {
  @Environment(\.dismiss) var dismiss

  @State private var allSubjects: [Subject] = []
  @State private var searchText = ""

  var filteredSubjects: [Subject] {
    searchText.isEmpty ? allSubjects :
    allSubjects.filter { $0.subjectName.lowercased().contains(searchText.lowercased()) }
  }

  var body: some View {
    NavigationStack {
      VStack {
        TextField("Search subject...", text: $searchText)
          .padding()
          .background(Color(UIColor.systemGray6))
          .cornerRadius(10)
          .padding(.horizontal)

        List(filteredSubjects) { subject in
          HStack {
            VStack(alignment: .leading) {
              Text(subject.subjectName).bold()
              Text(subject.subjectCode)
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            Spacer()
            Button {
              addSubjectToUser(subject)
            } label: {
              Text("Add")
                .foregroundColor(.purple)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .overlay(
                  RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.purple, lineWidth: 2)
                )
            }
          }
        }
        .listRowBackground(Color.white)
        .background(Color.white)
        .scrollContentBackground(.hidden)
      }
      .navigationTitle("Add Subject")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
      }
      .onAppear(perform: fetchSubjects)
    }
  }

  func fetchSubjects() {
    Firestore.firestore().collection("subjects").getDocuments { snapshot, _ in
      allSubjects = snapshot?.documents.map {
        Subject(
          id: $0.documentID,
          subjectCode: $0["subjectCode"] as? String ?? "",
          subjectName: $0["subjectName"] as? String ?? ""
        )
      } ?? []
    }
  }

  func addSubjectToUser(_ subject: Subject) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    Firestore.firestore().collection("users").document(uid).collection("subjects").document(subject.subjectCode).setData([
      "subjectCode": subject.subjectCode,
      "subjectName": subject.subjectName,
      "addedAt": Timestamp()
    ])

    dismiss()
  }
}

#Preview {
    AddSubjectScreen()
}
