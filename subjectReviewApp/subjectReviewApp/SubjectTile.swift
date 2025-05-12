//
//  SubjectTile.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher & Ilias Vasiliou on 12/5/2025.
//

import SwiftUI

struct SubjectTile: View {
  let subject: Subject

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(subject.subjectName)
        .font(.headline)

      Text(subject.subjectCode)
        .font(.subheadline)
        .foregroundColor(.gray)

      if let avg = subject.averageRating {
        HStack(spacing: 2) {
          ForEach(0..<5) { i in
            Image(systemName: i < Int(round(avg)) ? "star.fill" : "star")
              .foregroundColor(.yellow)
          }
          Text(String(format: "%.1f", avg))
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(UIColor.systemGray6))
    )
  }
}
