//
//  StatementListView.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import SwiftUI
import SwiftData

struct StatementListView: View {
    @Query(sort: \Statement.createdAt, order: .reverse) var statements: [Statement]

    var onTap: (Statement) -> Void

    var body: some View {
        List {
            ForEach(statements) { statement in
                VStack(alignment: .leading, spacing: 6) {
                    Text("💳 \(statement.cardName) - \(statement.bankName)")
                        .font(.headline)
                    Text("📄 \(statement.fileName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("🕒 \(statement.createdAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .onTapGesture {
                    onTap(statement)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview("StatementListView Preview") {
    StatementListView(onTap: { statement in
            print("Tapped on: \(statement.cardName)")
        }
    )
}
