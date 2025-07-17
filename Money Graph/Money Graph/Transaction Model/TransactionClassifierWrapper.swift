//
//  TransactionClassifierWrapper.swift
//  Money Graph
//
//  Created by Siva on 17/07/2025.
//

import Foundation
import PDFKit
import CoreML

class TransactionClassifierWrapper {
    let model: TransactionClassifier
    
    init() throws {
        model = try TransactionClassifier(configuration: MLModelConfiguration())
    }
    
    func predictCategory(description: String, amount: Double) -> String? {
        do {
            let input = TransactionClassifierInput(Description: description,
                                                   Amount: amount)
            let prediction = try model.prediction(input: input)
            return prediction.Category
        } catch {
            print("Prediction error: \(error)")
            return nil
        }
    }
}
