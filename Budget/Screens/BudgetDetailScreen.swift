//
//  BudgetDetailScreen.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import SwiftUI
import CoreData

struct EditExpenseConfig: Identifiable {
    let id = UUID()
    let expense: Expense
    let childContext: NSManagedObjectContext
    
    // context is parent context
    init?(expenseObjectID: NSManagedObjectID, context: NSManagedObjectContext) {
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = context
        guard let existingExpense = self.childContext.object(with: expenseObjectID) as? Expense else { return nil }
        self.expense = existingExpense
    }
}

struct BudgetDetailScreen: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var context
    
    let budget: Budget
    
    @State private var title: String = ""
    @State private var amount: Double?
    @State private var quantity: Int?
    
    @State private var showEditExpenseSheet: Bool = false
    @State private var errorMessage: String = ""
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var editExpenseConfig: EditExpenseConfig?
    
    init(budget: Budget) {
        
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
        
    }
    
    /// --Field Validation
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty && quantity != nil && Int(quantity!) > 0
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
                    TextField("Quantity", value: $quantity, format: .number)
                    
                    TagsView(selectedTags: $selectedTags)
                    
                    Button {
                        if !Expense.exists(context: context, title: title, budget: budget) {
                            addExpense()
                        } else {
                            errorMessage = "Expense title should be unique."
                        }
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
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
                                .onLongPressGesture {
                                    editExpenseConfig = EditExpenseConfig(expenseObjectID: expense.objectID, context: context)
                                }// onLongPressGesture
                                .sensoryFeedback(.selection, trigger: showEditExpenseSheet)
                        }// ForEach
                        .onDelete(perform: deleteExpense)
                    }// List
                    
                }// Expenses List
                
            }// Form
            .navigationTitle(budget.title ?? "")
            .sheet(item: $editExpenseConfig) { editExpenseConfig in
                EditExpenseScreen(expense: editExpenseConfig.expense) {
                    do {
                        try context.save()
                        self.editExpenseConfig = nil
                    } catch {
                        print(error)
                    }
                }
                .environment(\.managedObjectContext, editExpenseConfig.childContext)
                    
            }// sheet
        }// NavigationStack
    }// Body
    
    // MARK: - Methods
    private func addExpense() {
        
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        
        budget.addToExpenses(expense)
        
        do {
            try context.save()
            title = ""
            amount = nil
            quantity = nil
            selectedTags = []
            errorMessage = ""
            
        } catch {
            context.rollback()
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


