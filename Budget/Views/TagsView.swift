//
//  TagsView.swift
//  Budget
//
//  Created by Vlad on 31/5/25.
//

import SwiftUI

struct TagsView: View {
    // MARK: - Properties
    @FetchRequest(sortDescriptors: []) private var tags: FetchedResults<Tag>
    @Binding var selectedTags: Set<Tag>
    
    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tags) { tag in
                    Text(tag.name ?? "")
                        .padding(10)
                        .background(selectedTags.contains(tag) ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }
                }// ForEach
            }// HStack
            .foregroundStyle(.white)
        }// ScrollView
    }// Body
}// View

/// --Struct for preview
struct TagsViewContainerView: View {
    
    @State private var selectedTags: Set<Tag> = []
    
    var body: some View {
        TagsView(selectedTags: $selectedTags)
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

// MARK: - Preview
#Preview {
    TagsViewContainerView()
}
