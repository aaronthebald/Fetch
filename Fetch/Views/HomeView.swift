//
//  HomeView.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel(dataService: RecipeDataService(), cacheService: CacheService())

    var body: some View {
        NavigationStack {
            List(vm.recipes, rowContent: { recipe in
                RecipeTile(vm: vm, recipe: recipe)
                    .listRowSeparator(.hidden)

            })
            .listRowSpacing(10)
            .listStyle(.plain)
            
            .refreshable {
                await vm.fetchRecipes()
            }
            .task {
                await vm.fetchRecipes()
            }
            .navigationTitle("Fetch Take-Home")
        }
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    
}
