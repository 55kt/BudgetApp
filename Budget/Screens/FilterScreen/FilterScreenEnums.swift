//
//  FilterScreenEnums.swift
//  Budget
//
//  Created by Vlad on 2/6/25.
//

import Foundation

enum FilterOption: Identifiable, Equatable {
    case none, byTags(Set<Tag>), byPriceRange(minPrice: Double, maxPrice: Double), byTitle(String), byDate(startDate: Date, endDate: Date)
    
    var id: String {
        switch self {
        case .none:
            return "none"
        case .byTags:
            return "byTags"
        case .byPriceRange:
            return "byPriceRange"
        case .byTitle:
            return "byTitle"
        case .byDate:
            return "byDate"
        }
    }
}

enum SortOptions: String, CaseIterable, Identifiable {
    case title = "title", date = "dateCreated"
    
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
        rawValue
    }
}

enum SortDirection: CaseIterable, Identifiable {
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
