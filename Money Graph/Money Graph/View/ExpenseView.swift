//
//  ExpenseView.swift
//  Money Graph
//
//  Created by Siva on 06/07/2025.
//

import SwiftUI

struct ExpenseView: View {
    @StateObject var viewModel: ExpenseViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Prediction Result:")
                .font(.title2)
                .bold()

            if viewModel.predictionResult.isEmpty {
                Text("Analyzing...")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.predictionResult, id: \.self) { category in
                    Text("• \(category)")
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Expense Analysis")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview("ExpenseView Preview") {
    let mockViewModel = ExpenseViewModel(
        statement: Statement(
            cardName: "Visa Platinum",
            bankName: "Bank of Swift",
            fileURL: URL(fileURLWithPath: "/Users/user/Documents/statement1.pdf")
        )
    )
    ExpenseView(viewModel: mockViewModel)
}
