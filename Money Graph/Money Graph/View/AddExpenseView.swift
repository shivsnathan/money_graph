//
//  AddExpenseView.swift
//  Money Graph
//
//  Created by Siva on 27/06/2025.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel: AddExpenseViewModel

    @State private var isPickerPresented = false
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddExpenseViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Card Name", text: $viewModel.cardName)
                        TextField("Bank Name", text: $viewModel.bankName)
                    }
                }

                HStack(spacing: 16) {
                    Button {
                        isPickerPresented = true
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 24))
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    if let url = viewModel.selectedPDFURL {
                        Text(url.lastPathComponent)
                    } else {
                        Text("Upload Statement")
                    }
                }
                .padding()
            }
            .navigationTitle("Add Statement")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.saveStatement()
                        dismiss()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                DocumentPickerView { url in
                    viewModel.selectedPDFURL = url
                }
            }
        }
    }
}

#Preview {
    do {
        // 1. Create an in-memory model container for preview
        let container = try ModelContainer(for: Statement.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // 2. Inject the context into your view
        return AddExpenseView(modelContext: container.mainContext)
    } catch {
        // 3. Show fallback if container fails
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
