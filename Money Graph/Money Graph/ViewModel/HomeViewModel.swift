//
//  HomeViewModel.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import SwiftUI
import SwiftData
import PDFKit
import CoreML

@MainActor
class HomeViewModel: ObservableObject {
    func delete(_ statement: Statement, context: ModelContext) {
        context.delete(statement)
        try? context.save()
    }
}

