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
            if vm.showEmptyView {
                if #available(iOS 17, *) {
                    ContentUnavailableView("No recipes found", systemImage: "note.text")
                } else {
                    VStack {
                        Text("No Recipes were found")
                        Image(systemName: "note.text")
                    }
                }
            } else {
                List(vm.recipes, rowContent: { recipe in
                    RecipeTile(vm: vm, recipe: recipe)
                        .listRowSeparator(.hidden)
                        .shadow(radius: 6, y: 6)
                })
                .listRowSpacing(15)
                .listStyle(.plain)
                
                .refreshable {
                    await vm.fetchRecipes()
                }
                .task {
                    await vm.fetchRecipes()
                }
                .navigationTitle("Fetch Take-Home")
                .alert("Uh Oh", isPresented: $vm.showAlert) {
                    Button {
                        vm.showAlert = false
                    } label: {
                        Text("Dismiss")
                    }
                    
                } message: {
                    Text("There was an error fetching your recipes.")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
