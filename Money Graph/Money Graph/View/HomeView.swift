//
//  HomeView.swift
//  Money Graph
//
//  Created by Siva on 27/06/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var showAddExpenseSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "plus.circle")
                .font(.system(size: 75))
                .symbolEffect(.bounce.up.byLayer,
                              options: .nonRepeating)
                .frame(width: 100, height: 100)
                .foregroundStyle(.green)
                .onTapGesture {
                    showAddExpenseSheet = true
                }
            VStack(spacing: 5) {
                Text("Get Started")
                    .font(.headline)
                Text("Upload your statement to get going.")
            }
        }
        .sheet(isPresented: $showAddExpenseSheet) {
            AddExpenseView()
        }
    }
}

#Preview {
    HomeView()
}
