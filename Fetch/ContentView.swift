//
//  ContentView.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = HomeViewModel()
    var body: some View {
        ScrollView {
            ForEach(vm.recipes) { recipe in
                Text(recipe.name)
            }
        }
        .padding()
        .task {
            await vm.fetchRecipes()
        }
    }
}

#Preview {
    ContentView()
}
