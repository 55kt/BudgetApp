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
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Section("Filtered by tags") {
                    TagsView(selectedTags: $selectedTags)
                        .onChange(of: selectedTags, filterTags)
                }// Section
                
                List(filteredExpenses) { expense in
                    ExpenseCellView(expense: expense)
                }// List
                Spacer()
            }// VStack
            .padding()
            .navigationTitle("Filter")
        }// NavigationStack
    }// Body
    
    // MARK: - Methods
    private func filterTags() {
        let selectedTagNames = selectedTags.map { $0.name }
        
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
        
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
