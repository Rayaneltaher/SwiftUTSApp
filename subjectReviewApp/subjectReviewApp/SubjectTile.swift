//
//  SubjectTile.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 12/5/2025.
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
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemGray6))
        )
    }
}
