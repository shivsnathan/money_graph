//
//  HomeView.swift
//  Money Graph
//
//  Created by Siva on 27/06/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var showAddExpenseSheet = false
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedStatement: Statement? = nil
    @State private var navigateToExpense = false

    @Query(sort: \Statement.createdAt, order: .reverse) var statements: [Statement]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if statements.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 75))
                            .symbolEffect(.bounce.up.byLayer,
                                          options: .nonRepeating)
                            .foregroundStyle(.green)
                            .onTapGesture {
                                showAddExpenseSheet = true
                            }
                        VStack(spacing: 5) {
                            Text("Get Started").font(.headline)
                            Text("Upload your statement to get going.")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    StatementListView(
                        onTap: { statement in
                            selectedStatement = statement
                            navigateToExpense = true
                        },
                        onDelete: { statement in
                            viewModel.delete(statement, context: modelContext)
                        })
                    .navigationDestination(isPresented: $navigateToExpense) {
                        if let statement = selectedStatement {
                            ExpenseView(viewModel: ExpenseViewModel(statement: statement))
                        }
                    }
                }

                if !statements.isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Color.green)
                            .clipShape(Circle())
                            .onTapGesture {
                                showAddExpenseSheet = true
                            }

                        Text("Upload new statement")
                            .font(.headline)
                            .onTapGesture {
                                showAddExpenseSheet = true
                            }

                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                    .shadow(radius: 5)
                }
            }
            .sheet(isPresented: $showAddExpenseSheet) {
                AddExpenseView(modelContext: modelContext)
            }
            .navigationTitle(statements.isEmpty ? "" : "My Statements")
        }
    }
}


#Preview {
    HomeView()
}
