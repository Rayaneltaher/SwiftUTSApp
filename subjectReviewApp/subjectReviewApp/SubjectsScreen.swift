//
//  SubjectsScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 10/5/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SubjectsScreen: View {
  @State private var userSubjects: [Subject] = []
  @State private var showAddSubject = false

  var body: some View {
    NavigationStack {
      List {
        ForEach(userSubjects) { subject in
          SubjectTile(subject: subject)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .onDelete(perform: deleteSubject)
      }
      .listStyle(.plain)
      .navigationTitle("My Subjects")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            showAddSubject = true
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .onAppear(perform: loadUserSubjects)
      .sheet(isPresented: $showAddSubject, onDismiss: loadUserSubjects) {
        AddSubjectScreen()
      }
    }
  }

  func loadUserSubjects() {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    Firestore.firestore().collection("users").document(uid).collection("subjects")
      .order(by: "addedAt")
      .getDocuments { snapshot, _ in
        userSubjects = snapshot?.documents.map {
          Subject(
            id: $0.documentID,
            subjectCode: $0["subjectCode"] as? String ?? "",
            subjectName: $0["subjectName"] as? String ?? ""
          )
        } ?? []
      }
  }

  func deleteSubject(at offsets: IndexSet) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    offsets.forEach { index in
      let subject = userSubjects[index]
      Firestore.firestore().collection("users").document(uid).collection("subjects").document(subject.subjectCode).delete()
    }
    userSubjects.remove(atOffsets: offsets)
  }
}

#Preview {
  SubjectsScreen()
}
