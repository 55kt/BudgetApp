//
//  ContentView.swift
//  Budget
//
//  Created by Vlad on 27/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Vlassis!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
