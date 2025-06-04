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
    @State private var isFilterPresented: Bool = false
    private var total: Double {
        budgets.reduce(0) { limit, budget in
            budget.limit + limit
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                
                if budgets.isEmpty {
                    ContentUnavailableView("No budget avaliable.", systemImage: "list.clipboard")
                } else {
                    List {
                        HStack {
                            Spacer()
                            Text("Total Limit")
                            Text(total, format: .currency(code: Locale.currencyCode))
                            Spacer()
                        }// HStack
                        .font(.headline)
                        ForEach(budgets) { budget in
                            NavigationLink(destination: BudgetDetailScreen(budget: budget)) {
                                BudgetCellView(budget: budget)
                            }// NavigationLink
                        }// ForEach
                    }// List
                }// if - else
                
            }// VStack
            .overlay(alignment: .bottom, content: {
                Button("Filter") {
                    isFilterPresented = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            })// overlay
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
            .sheet(isPresented: $isFilterPresented) {
                FilterScreen()
            }// sheet
        }// NavigationStack
    }// Body
}// View

// MARK: - Preview
#Preview {
    BudgetListScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
