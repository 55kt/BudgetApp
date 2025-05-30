//
//  BudgetListScreen.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI

struct BudgetListScreen: View {
    // MARK: - Properties
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isPresented: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                List(budgets) { budget in
                    Text(budget.title ?? "")
                }// List
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
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
