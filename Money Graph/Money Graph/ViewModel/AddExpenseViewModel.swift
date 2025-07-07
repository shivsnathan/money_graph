//
//  AddExpenseViewModel.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import SwiftUI
import SwiftData
import PDFKit
import CoreML

@MainActor
class AddExpenseViewModel: ObservableObject {
    @Published var cardName = ""
    @Published var bankName = ""
    @Published var selectedPDFURL: URL? = nil

    private var modelContext: ModelContext
    
    init (modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var isFormValid: Bool {
        !cardName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !bankName.trimmingCharacters(in: .whitespaces).isEmpty &&
        selectedPDFURL != nil
    }

    func saveStatement() {
        guard let url = selectedPDFURL else { return }
        let statement = Statement(cardName: cardName, bankName: bankName, fileURL: url)
        modelContext.insert(statement)
        clearForm()
    }

    func clearForm() {
        cardName = ""
        bankName = ""
        selectedPDFURL = nil
    }
}

