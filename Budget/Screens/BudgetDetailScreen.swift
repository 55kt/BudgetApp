//
//  BudgetDetailScreen.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI

struct BudgetDetailScreen: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var context
    
    let budget: Budget
    
    @State private var title: String = ""
    @State private var amount: Double?
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    init(budget: Budget) {
        
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
        
    }
    
    /// --Field Validation
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0
    }
    
    private var total: Double {
        return expenses.reduce(0) { result, expense in
            expense.amount + result
        }
    }
    
    private var remaining: Double {
        budget.limit - total
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("New expense") {
                    TextField("Title", text: $title)
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                    
                    Button {
                        addExpense()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                }// New expense section
                
                Section("Expenses") {
                    
                    List {
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                Text("Total")
                                Text(total, format: .currency(code: Locale.currencyCode))
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Text("Remaining")
                                Text(remaining, format: .currency(code: Locale.currencyCode))
                                    .foregroundStyle(remaining < 0 ? .red : .green)
                                Spacer()
                            }
                        }// VStack
                        
                        ForEach(expenses) { expense in
                            HStack {
                                Text(expense.title ?? "")
                                Spacer()
                                Text(expense.amount, format: .currency(code: Locale.currencyCode))
                            }// HStack
                        }// ForEach
                    }// List
                    
                }// Expenses List
                
            }// Form
            .navigationTitle(budget.title ?? "")
        }// NavigationStack
    }// Body
    
    // MARK: - Methods
    private func addExpense() {
        
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.dateCreated = Date()
        
        budget.addToExpenses(expense)
        
        do {
            try context.save()
            title = ""
            amount = nil
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}// View

/// --Preview Struct
struct BudgetDetailScreenContainer: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    var body: some View {
        BudgetDetailScreen(budget: budgets.first(where:  { $0.title == "Sailing" })!)
    }
}

// MARK: - Preview
#Preview {
    BudgetDetailScreenContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
