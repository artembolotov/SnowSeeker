//
//  ContentView.swift
//  SnowSeeker
//
//  Created by artembolotov on 19.07.2023.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self
                .navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    @State private var selectedOrder = SearchType.initial
    
    var body: some View {
        NavigationView {
            List(orderedResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: 1)
                            }
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.containts(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Resorts")
            .toolbar {
                ToolbarItem {
                    HStack {
                        Picker("Sort", selection: $selectedOrder) {
                            Text("Regular").tag(SearchType.initial)
                            Text("Alphabetical").tag(SearchType.alphabetical)
                            Text("By country").tag(SearchType.country)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for resort")
            
            WelcomeView()
        }
        .environmentObject(favorites)
        //.phoneOnlyNavigationView()
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var orderedResorts: [Resort] {
        switch selectedOrder {
        case .initial:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { $0.name < $1.name}
        case .country:
            return filteredResorts.sorted {$0.country < $1.country }
        }
    }
    
    enum SearchType {
        case initial, alphabetical, country
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
