//
//  HomeView.swift
//  Fetch
//
//  Created by Aaron Wilson on 2/15/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel(
        dataService: RecipeDataService(urlString: Constants.functionalURLString),
        cacheService: CacheService()
    )
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.showEmptyResultsView {
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
                    .alert("Uh Oh", isPresented: $vm.showAlert) {
                        Button {
                            vm.showAlert = false
                        } label: {
                            Text("Dismiss")
                        }
                    } message: {
                        Text(vm.alertMessage)
                    }
                }
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
