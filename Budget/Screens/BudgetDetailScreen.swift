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
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    init(budget: Budget) {
        
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
        
    }
    
    /// --Field Validation
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                
                Text("Total \(budget.title ?? "") budget is \(budget.limit, format: .currency(code: Locale.currencyCode))")
                
                Section("New expense") {
                    TextField("Title", text: $title)
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                    
                    TagsView(selectedTags: $selectedTags)
                    
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
                                Text("Spent")
                                Text(budget.spent, format: .currency(code: Locale.currencyCode))
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Text("Remaining")
                                Text(budget.remaining, format: .currency(code: Locale.currencyCode))
                                    .foregroundStyle(budget.remaining < 0 ? .red : .green)
                                Spacer()
                            }
                        }// VStack
                        
                        ForEach(expenses) { expense in
                            ExpenseCellView(expense: expense)
                        }// ForEach
                        .onDelete(perform: deleteExpense)
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
        expense.tags = NSSet(array: Array(selectedTags))
        
        budget.addToExpenses(expense)
        
        do {
            try context.save()
            title = ""
            amount = nil
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func deleteExpense(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}// View

/// --Preview Container
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


