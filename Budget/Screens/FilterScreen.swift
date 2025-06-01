//
//  FilterScreen.swift
//  Budget
//
//  Created by Vlad on 1/6/25.
//

import SwiftUI

struct FilterScreen: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) private var context
    @State private var selectedTags: Set<Tag> = []
    @State private var filteredExpenses: [Expense] = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var startPrice: Double?
    @State private var endPrice: Double?
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Section("Filtered by tags") {
                    TagsView(selectedTags: $selectedTags)
                        .onChange(of: selectedTags, filterTags)
                }// Section for filtering by tags
                
                Section("Filter by price") {
                    TextField("Start Price", value: $startPrice, format: .number)
                    TextField("End Price", value: $endPrice, format: .number)
                    Button("Search") {
                        filterByPrice()
                    }
                }// Section for filtering by price
                
                List(filteredExpenses) { expense in
                    ExpenseCellView(expense: expense)
                }// List
                Spacer()
                
                HStack {
                    Spacer()
                    Button("Show all") {
                        selectedTags = []
                        filteredExpenses = expenses.map { $0 }
                    }
                    Spacer()
                }// HStack
            }// VStack
            .padding()
            .navigationTitle("Filter")
        }// NavigationStack
    }// Body
    
    // MARK: - Methods
    private func filterTags() {
        if selectedTags.isEmpty {
            return
        }
        let selectedTagNames = selectedTags.map { $0.name }
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByPrice() {
        guard let startPrice = startPrice, let endPrice = endPrice else { return }
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: startPrice), NSNumber(value: endPrice))
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
}// View

// MARK: - Preview
#Preview {
    FilterScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
