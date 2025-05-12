//
//  SubjectsScreen.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher & Ilias Vasiliou on 10/5/2025.
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
          NavigationLink(destination: SubjectDetailScreen(subject: subject)) {
            SubjectTile(subject: subject)
          }
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
        let docs = snapshot?.documents ?? []
        var tempSubjects: [Subject] = []
        let group = DispatchGroup()

        for doc in docs {
          let subjectCode = doc["subjectCode"] as? String ?? ""
          let subjectName = doc["subjectName"] as? String ?? ""
          let subjectId = doc.documentID

          group.enter()
          Firestore.firestore().collection("subjects").document(subjectCode).collection("reviews")
            .getDocuments { reviewSnapshot, _ in
              let reviews = reviewSnapshot?.documents ?? []
              let ratings = reviews.compactMap { $0["rating"] as? Int }
              let avg = ratings.isEmpty ? nil : Double(ratings.reduce(0, +)) / Double(ratings.count)

              let s = Subject(
                id: subjectId,
                subjectCode: subjectCode,
                subjectName: subjectName,
                averageRating: avg,
                reviewCount: ratings.count
              )
              tempSubjects.append(s)
              group.leave()
            }
        }

        group.notify(queue: .main) {
          self.userSubjects = tempSubjects.sorted { $0.subjectCode < $1.subjectCode }
        }
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
