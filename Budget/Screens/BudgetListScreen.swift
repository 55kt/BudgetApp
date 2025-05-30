//
//  BudgetListScreen.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI

struct BudgetListScreen: View {
    // MARK: - Properties
    @State private var isPresented: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Text("Budget will be here....")
            }// VStack
            .navigationTitle("Budget App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Budget") {
                        isPresented = true
                    }
                }
            }// toolbar
            .sheet(isPresented: $isPresented) {
                AddBudgetScreen()
                    .presentationDetents([.medium])
            }// sheet
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    BudgetListScreen()
}
