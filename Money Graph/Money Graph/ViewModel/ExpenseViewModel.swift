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
        processPDF(url: statement.fileURL)
    }

    func processPDF(url: URL) {
        guard statement.fileURL.startAccessingSecurityScopedResource() else { return }
        defer { statement.fileURL.stopAccessingSecurityScopedResource() }
        
        let model = try! TransactionClassifier(configuration: MLModelConfiguration())
        
        let pdfText = extractTextFromPDF(url: url)
        let rawTransactions = parseTransactions(from: pdfText)
        
        var categoryTotals: [Int: Double] = [:]
        
//        for tx in rawTransactions {
//            if let category = predictCategory(for: tx, model: model) {
//                categoryTotals[category, default: 0.0] += tx.amount
//            }
//        }
        
        // Show results
//        print("Spending by category ID:", categoryTotals)
    }

    func extractTextFromPDF(url: URL) -> String {
        guard let pdf = PDFDocument(url: url) else { return "" }
        var fullText = ""
        
        for pageIndex in 0..<pdf.pageCount {
            guard let page = pdf.page(at: pageIndex),
                  let pageText = page.string else { continue }
            fullText += pageText + "\n"
        }
        
        return fullText
    }

    func parseTransactions(from text: String) -> [RawTransaction] {
        let lines = text.components(separatedBy: .newlines)
        var transactions: [RawTransaction] = []
        
        let pattern = #"(\d{2}-\d{2}-\d{4})\s+(.+?)\s+([\d]+\.\d{2})"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        for line in lines {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range),
               let dateRange = Range(match.range(at: 1), in: line),
               let merchantRange = Range(match.range(at: 2), in: line),
               let amountRange = Range(match.range(at: 3), in: line) {
                
                let date = String(line[dateRange])
                let merchant = String(line[merchantRange])
                let amount = Double(line[amountRange]) ?? 0.0
                transactions.append(RawTransaction(date: date, merchant: merchant, amount: amount))
            }
        }
        return transactions
    }
    
//    func predictCategory(for transaction: RawTransaction, model: TransactionClassifier) -> String? {
//           // Use merchant name as input; adjust if your model expects more
//           let inputString = transaction.merchant
//           do {
//               let input = TransactionClassifierInput(sentence: inputString)
//               let prediction = try model.prediction(input: input)
//               return prediction.category // or whatever your model's output property is called
//           } catch {
//               print("Prediction error: \(error)")
//               return nil
//           }
//       }
    
    
//    func predictCategory(for transaction: RawTransaction, model: TransactionClassifier) -> Int? {
//        let logAmt = log(1 + transaction.amount)
//        let hour: Double = 14  // placeholder
//        let distance: Double = 5.0  // placeholder
//        
//        // You must create full one-hot encoded vector here
//        let inputDict: [String: Any] = [
//            "log_amt": logAmt,
//            "hour": hour,
//            "distance": distance,
//            // ... include other required inputs like one-hot merchant, gender, etc.
//        ]
//        
//        do {
//            let inputProvider = try MLDictionaryFeatureProvider(dictionary: inputDict)
//            let prediction = try model.prediction(from: inputProvider)
//            return prediction.featureValue(for: "category")?.intValue
//        } catch {
//            print("Prediction failed: \(error)")
//            return nil
//        }
//    }
}

struct RawTransaction {
    let date: String
    let merchant: String
    let amount: Double
}
