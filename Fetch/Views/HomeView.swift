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
        ScrollView {
            LazyVStack {
                ForEach(vm.recipes) { recipe in
                    RecipeTile(vm: vm, recipe: recipe)
                        .frame(width: 300, height: 300)
                }
            }
            
        }
        .padding()
        .task {
            await vm.fetchRecipes()
        }
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    
}
