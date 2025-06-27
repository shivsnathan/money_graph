//
//  AddExpenseView.swift
//  Money Graph
//
//  Created by Siva on 27/06/2025.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var cardName = ""
    @State private var bankName = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("")) {
                        TextField("Card Name", text: $cardName)
                        TextField("Bank Name", text: $bankName)
                    }
                }
                
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "document.badge.plus")
                            .font(.system(size: 24))
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    Text("Upload Statement")
                        .font(.headline)
                }
            }
            .navigationTitle("Add Statement")
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    AddExpenseView()
}
