//
//  EditExpenseScreen.swift
//  Budget
//
//  Created by Vlad on 8/6/25.
//

import SwiftUI

struct EditExpenseScreen: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let expense: Expense
    
    @State private var expenseTitle: String = ""
    @State private var expenseAmount: Double?
    @State private var expenseQuantity: Int = 0
    @State private var expenseSelectedTags: Set<Tag> = []
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $expenseTitle)
                TextField("Amount", value: $expenseAmount, format: .number)
                TextField("Quantity", value: $expenseQuantity, format: .number)
                TagsView(selectedTags: $expenseSelectedTags)
            }// Form
            .onAppear(perform: {
                expenseTitle = expense.title ?? ""
                expenseAmount = expense.amount
                expenseQuantity = Int(expense.quantity)
                if let tags = expense.tags {
                    expenseSelectedTags = Set(tags.compactMap {$0 as? Tag} )
                }// if
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Update") {
                        updateExpense()
                    }
                }
            }// toolbar
            .navigationTitle(expense.title ?? "")
        }// NavigationStack
    }// Body
    
    // MARK: - Methods
    private func updateExpense() {
        expense.title = expenseTitle
        expense.amount = expenseAmount ?? 0.0
        expense.quantity = Int16(expenseQuantity)
        expense.tags = NSSet(array: Array(expenseSelectedTags))
        
        do {
            try context.save()
            dismiss()
        } catch {
            print(error)
        }
    }
    
}// View

// MARK: - Preview Container
struct EditExpenseContainerView: View {
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    var body: some View {
        NavigationStack {
            EditExpenseScreen(expense: expenses[0])
        }
    }
}

// MARK: - Preview
#Preview {
    EditExpenseContainerView()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
