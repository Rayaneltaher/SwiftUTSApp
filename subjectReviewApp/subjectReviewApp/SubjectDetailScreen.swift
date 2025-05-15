//
//  SubjectDetailScreen.swift
//  subjectReviewApp
//
//  Created by Ilias Vasiliou on 12/5/2025.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Review: Identifiable {
    var id: String
    var rating: Int
    var description: String
    var userId: String
}

struct SubjectDetailScreen: View {
    let subject: Subject

    @State private var reviews: [Review] = []
    @State private var newRating: Int = 3
    @State private var newDescription: String = ""
    @State private var averageRating: Double? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(subject.subjectName)
                    .font(.title)
                    .bold()

                if let avg = averageRating {
                    HStack {
                        ForEach(0..<5) { i in
                            Image(systemName: i < Int(round(avg)) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        Text(String(format: "%.1f", avg))
                            .foregroundColor(.gray)
                    }
                }

                Divider()

                Text("Reviews")
                    .font(.headline)

                if reviews.isEmpty {
                    Text("No reviews yet. Be the first!")
                        .foregroundColor(.gray)
                } else {
                    ForEach(reviews) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { i in
                                    Image(systemName: i < review.rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }
                            Text(review.description)
                                .font(.subheadline)
                            Divider()
                        }
                    }
                }

                Spacer().frame(height: 32)

                Text("Leave a Review")
                    .font(.headline)

                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= newRating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                newRating = star
                            }
                    }
                }

                TextField("Write something...", text: $newDescription)
                    .textFieldStyle(.roundedBorder)

                Button("Submit Review") {
                    submitReview()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)

                NavigationLink(destination: DownloadOutlineScreen(subjectCode: subject.subjectCode)) {
                    Text("Download Outline")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(subject.subjectCode)
        .onAppear(perform: loadReviews)
    }

    func loadReviews() {
        Firestore.firestore().collection("subjects").document(subject.subjectCode).collection("reviews")
            .order(by: "rating", descending: true)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                var loaded: [Review] = []

                for doc in docs {
                    let data = doc.data()
                    let review = Review(
                        id: doc.documentID,
                        rating: data["rating"] as? Int ?? 0,
                        description: data["description"] as? String ?? "",
                        userId: data["userId"] as? String ?? ""
                    )
                    loaded.append(review)
                }

                self.reviews = loaded
                if !loaded.isEmpty {
                    let total = loaded.map { $0.rating }.reduce(0, +)
                    self.averageRating = Double(total) / Double(loaded.count)
                }
            }
    }

    func submitReview() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let reviewData: [String: Any] = [
            "rating": newRating,
            "description": newDescription,
            "userId": userId,
            "timestamp": FieldValue.serverTimestamp()
        ]

        Firestore.firestore().collection("subjects").document(subject.subjectCode).collection("reviews")
            .addDocument(data: reviewData) { error in
                if error == nil {
                    newDescription = ""
                    newRating = 3
                    loadReviews()
                }
            }
    }
}

#Preview {
    SubjectDetailScreen(subject: Subject(id: "31251", subjectCode: "31251", subjectName: "Data Structures and Algorithms"))
}
