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
    
    @ObservedObject var expense: Expense
    let onUpdate: () -> Void
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: Binding(
                    get: { expense.title ?? "" },
                    set: { newValue in
                        expense.title = newValue
                    }
                ))
                TextField("Amount", value: $expense.amount, format: .number)
                TextField("Quantity", value: $expense.quantity, format: .number)
                TagsView(selectedTags: Binding(
                    get: { Set(expense.tags?.compactMap { $0 as? Tag } ?? []) },
                    set: { newValue in
                        expense.tags = NSSet(array: Array(newValue))
                    }
                ))
            }// Form
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
        do {
            try context.save()
            onUpdate()
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
            EditExpenseScreen(expense: expenses[0], onUpdate: {})
        }
    }
}

// MARK: - Preview
#Preview {
    EditExpenseContainerView()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
