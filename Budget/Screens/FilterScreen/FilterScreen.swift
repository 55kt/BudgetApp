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
    
    @State private var selectedFilterOption: FilterOption? = nil
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section("Sort") {
                    Picker("Sort Options", selection: $selectedSortOption) {
                        ForEach(SortOptions.allCases) { option in
                            Text(option.title)
                                .tag(Optional(option))
                        }
                    }
                    .onChange(of: selectedSortOption) {
                        performSort()
                    }
                    
                    Picker("Sort Direction", selection: $selectedSortDirection) {
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
                        .onChange(of: selectedTags, {
                            selectedFilterOption = .byTags(selectedTags)
                        })
                }// Section for filtering by tags
                
                Section("Filter by price") {
                    TextField("Start Price", value: $startPrice, format: .number)
                    TextField("End Price", value: $endPrice, format: .number)
                    Button("Search") {
                        guard let startPrice = startPrice,
                              let endPrice = endPrice else { return }
                        selectedFilterOption = .byPriceRange(minPrice: startPrice, maxPrice: endPrice)
                    }
                }// Section for filtering by price
                
                Section("Filter by title") {
                    TextField("Title", text: $title)
                    Button("Search") {
                        selectedFilterOption = .byTitle(title)
                    }
                }// Section for filtering by title
                
                Section("Filter by date") {
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End date", selection: $endDate, displayedComponents: .date)
                    
                    Button("Search") {
                        selectedFilterOption = .byDate(startDate: startDate, endDate: endDate)
                    }
                }// Section for filtering by date
                
                Section("Expenses") {
                    ForEach(filteredExpenses) { expense in
                        ExpenseCellView(expense: expense)
                    }// ForEach
                    
                    
                    HStack {
                        Spacer()
                        Button("Show all") {
                            selectedFilterOption = FilterOption.none
                        }
                        Spacer()
                    }// HStack
                }// Expenses Section
            }// List
            .onChange(of: selectedFilterOption, performFilter)
            .padding()
            .navigationTitle("Filter")
        }// NavigationStack
    }// Body
    
    // MARK: - Methods
    
    private func performFilter() {
        
        guard let selectedFilterOption = selectedFilterOption else { return }
        
        let request = Expense.fetchRequest()
        
        switch selectedFilterOption {
            case .none:
                request.predicate = NSPredicate(value: true)
        case .byTags(let tags):
            let tagNames = tags.map { $0.name }
            request.predicate = NSPredicate(format: "ANY tags.name IN %@", tagNames)
        case .byPriceRange(let minPrice, let maxPrice):
            request.predicate = NSPredicate(format: "amount >= %@ AND amount <= %@", NSNumber(value: minPrice), NSNumber(value: maxPrice))
        case .byTitle(let title):
            request.predicate = NSPredicate(format: "title BEGINSWITH %@", title)
        case .byDate(let startDate, let endDate):
            request.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        }
        
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
    
}// View

// MARK: - Preview
#Preview {
    FilterScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
