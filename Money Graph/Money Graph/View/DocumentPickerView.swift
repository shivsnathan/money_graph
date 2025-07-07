//
//  DocumentPickerView.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    var completion: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completion)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types = [UTType.pdf]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let completion: (URL) -> Void

        init(completion: @escaping (URL) -> Void) {
            self.completion = completion
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }

            // 🔓 Make sure the app can access the file
            url.startAccessingSecurityScopedResource()
            defer { url.stopAccessingSecurityScopedResource() }

            completion(url)
        }
    }
}

#Preview {
    DocumentPickerView { url in
        print("Selected PDF URL: \(url)")
    }
}
