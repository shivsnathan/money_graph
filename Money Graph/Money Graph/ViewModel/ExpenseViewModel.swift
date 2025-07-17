//
//  ExpenseViewModel.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import SwiftUI
import PDFKit
import CoreML

@MainActor
class ExpenseViewModel: ObservableObject {
    @Published var predictionResult: [String] = []
    private let statement: Statement

    init(statement: Statement) {
        self.statement = statement
    }
    
    func analyzeStatementPDF() {
        guard let pdfText = extractText(from: statement.fileURL) else {
            print("Failed to extract PDF text")
            return
        }
        
        let transactions = parseTransactions(from: pdfText)
        print("Parsed transactions: \(transactions.count)")
        
        do {
            let classifier = try TransactionClassifierWrapper()
            
            for tx in transactions {
                if let category = classifier.predictCategory(description: tx.description, amount: tx.amount) {
                    print("Desc: \(tx.description), Amount: \(tx.amount), Category: \(category)")
                } else {
                    print("Prediction failed for: \(tx.description)")
                }
            }
        } catch {
            print("Error loading model: \(error)")
        }
    }

    // Step 1: Extract text from PDF
    func extractText(from pdfURL: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: pdfURL) else { return nil }
        var fullText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                fullText += page.string ?? ""
                fullText += "\n"  // separate pages
            }
        }
        print(fullText)
        return fullText
    }

    // Step 2: Parse transactions from text
    // Assuming each transaction is one line in format: "2025-07-15 Grocery Store 123.45"
    // Adjust regex or parsing logic based on your statement format!
    func parseTransactions(from text: String) -> [(description: String, amount: Double)] {
        var results: [(String, Double)] = []

        // Match lines like "09/03/2025 10/03/2025 SUPER MARKET GRANITE 2 ABU DHABI ARE 3.75"
        let pattern = #"(\d{2}/\d{2}/\d{4})\s+(\d{2}/\d{2}/\d{4})\s+(.+?)\s+ARE\s+([\d\.]+)"#
        let regex = try! NSRegularExpression(pattern: pattern)

        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regex.matches(in: text, options: [], range: range)

        for match in matches {
            if match.numberOfRanges == 5,
               let descriptionRange = Range(match.range(at: 3), in: text),
               let amountRange = Range(match.range(at: 4), in: text),
               let amount = Double(text[amountRange]) {

                let description = text[descriptionRange].trimmingCharacters(in: .whitespacesAndNewlines)
                results.append((description: description.lowercased(), amount: amount))
            }
        }

        return results
    }
}

struct RawTransaction {
    let date: String
    let merchant: String
    let amount: Double
}
