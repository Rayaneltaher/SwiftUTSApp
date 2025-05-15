//
//  DownloadOutlineScreen.swift
//  subjectReviewApp
//
//  Created by Ilias Vasiliou on 16/5/2025.
//

import SwiftUI
import QuickLook

struct DownloadOutlineScreen: View {
    let subjectCode: String
    @Environment(\.dismiss) var dismiss

    @State private var session = ""
    @State private var year = ""
    @State private var location = ""

    @State private var isDownloading = false
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false
    @State private var downloadedPDFURL: URL? = nil
    @State private var showPDFPreview = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter Parameters")) {
                    TextField("Session (e.g. AUT, SPR)", text: $session)
                    TextField("Year (e.g. 2024)", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Location (e.g. city)", text: $location)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: downloadPDF) {
                    if isDownloading {
                        ProgressView()
                    } else {
                        Text("Download PDF")
                    }
                }
                .disabled(session.isEmpty || year.isEmpty || location.isEmpty || isDownloading)
            }
            .navigationTitle("Download Outline")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Download Successful", isPresented: $showSuccessAlert) {
                Button("Open PDF") {
                    showPDFPreview = true
                }
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("The outline was downloaded successfully and saved to your Files.")
            }
        }
        .sheet(isPresented: $showPDFPreview) {
            if let url = downloadedPDFURL {
                PDFPreview(url: url)
            }
        }
    }

    func downloadPDF() {
        guard let baseURL = URL(string: "https://cis-admin-api.uts.edu.au/subject-outlines/index.cfm/PDFs") else {
            errorMessage = "Invalid URL"
            return
        }

        isDownloading = true
        errorMessage = nil

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "subjectCode", value: subjectCode),
            URLQueryItem(name: "lastGenerated", value: "true"),
            URLQueryItem(name: "mode", value: "standard"),
            URLQueryItem(name: "session", value: session),
            URLQueryItem(name: "year", value: year),
            URLQueryItem(name: "location", value: location)
        ]

        guard let finalURL = components.url else {
            errorMessage = "Failed to build request"
            isDownloading = false
            return
        }

        let task = URLSession.shared.downloadTask(with: finalURL) { tempURL, response, error in
            DispatchQueue.main.async {
                isDownloading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Download failed: \(error.localizedDescription)"
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        errorMessage = "Server returned status code \(httpResponse.statusCode)"
                    }
                    return
                }
            }

            guard let tempURL = tempURL else {
                DispatchQueue.main.async {
                    errorMessage = "No file received."
                }
                return
            }

            do {
                let fileManager = FileManager.default
                let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileName = "\(subjectCode)_Outline.pdf"
                let destinationURL = documents.appendingPathComponent(fileName)

                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }

                try fileManager.moveItem(at: tempURL, to: destinationURL)

                DispatchQueue.main.async {
                    downloadedPDFURL = destinationURL
                    showSuccessAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Saving failed: \(error.localizedDescription)"
                }
            }
        }

        task.resume()
    }
}

struct PDFPreview: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL

        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            url as QLPreviewItem
        }
    }
}
