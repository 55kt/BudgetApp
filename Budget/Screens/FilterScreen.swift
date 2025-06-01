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
    
    @State private var title: String = ""
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var selectedSortOption: SortOptions? = .title
    @State private var selectedSortDirection: SortDirection? = .ascending
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section("Sort") {
                    Picker("Sort Options", selection: $selectedSortOption) {
                        Text("").tag(Optional<SortOptions>(nil))
                        ForEach(SortOptions.allCases) { option in
                            Text(option.title)
                                .tag(Optional(option))
                        }
                    }
                    .onChange(of: selectedSortOption) {
                        performSort()
                    }
                    
                    Picker("Sort Direction", selection: $selectedSortDirection) {
                        Text("").tag(Optional<SortDirection>(nil))
                        ForEach(SortDirection.allCases) { option in
                            Text(option.title)
                                .tag(Optional(option))
                        }
                    }
                    .onChange(of: selectedSortDirection) {
                        performSort()
                    }
                }// Sort section
                
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
                
                Section("Filter by title") {
                    TextField("Title", text: $title)
                    Button("Search") {
                        filterByTitle()
                    }
                }// Section for filtering by title
                
                Section("Filter by date") {
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End date", selection: $endDate, displayedComponents: .date)
                    
                    Button("Search") {
                        filterByDate()
                    }
                }// Section for filtering by date
                
                Section("Expenses") {
                    ForEach(filteredExpenses) { expense in
                        ExpenseCellView(expense: expense)
                    }// ForEach
                    
                    
                    HStack {
                        Spacer()
                        Button("Show all") {
                            selectedTags = []
                            filteredExpenses = expenses.map { $0 }
                        }
                        Spacer()
                    }// HStack
                }// Expenses Section
            }// List
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
    
    private func filterByTitle() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func filterByDate() {
        let request = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func performSort() {
        guard let sortOption = selectedSortOption else { return }
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirection == .ascending ? true : false)]
        
        do {
            filteredExpenses = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private enum SortOptions: CaseIterable, Identifiable {
        case title, date
        
        var id: SortOptions {
            return self
        }
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .date:
                return "Date"
            }
        }
        
        var key: String {
            switch self {
            case .title:
                return "title"
            case .date:
                return "dateCreated"
            }
        }
    }
    
    private enum SortDirection: CaseIterable, Identifiable {
        case ascending, descending
        
        var id: SortDirection {
            return self
        }
        
        var title: String {
            switch self {
            case .ascending:
                return "Ascending"
            case .descending:
                return "Descending"
            }
        }
    }
    
}// View

// MARK: - Preview
#Preview {
    FilterScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
