//
//  Statement.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import Foundation
import SwiftData

@Model
class Statement {
    @Attribute(.unique) var id: UUID
    var cardName: String
    var bankName: String
    var fileURL: URL
    var fileName: String
    var createdAt: Date

    init(cardName: String, bankName: String, fileURL: URL) {
        self.id = UUID()
        self.cardName = cardName
        self.bankName = bankName
        self.fileURL = fileURL
        self.fileName = fileURL.lastPathComponent
        self.createdAt = Date()
    }
}

