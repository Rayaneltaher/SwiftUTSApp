//
//  Subject.swift
//  subjectReviewApp
//
//  Created by Rayan El Taher on 12/5/2025.
//

struct Subject: Identifiable {
    var id: String
    var subjectCode: String
    var subjectName: String
    var averageRating: Double? = nil
    var reviewCount: Int? = nil
}
