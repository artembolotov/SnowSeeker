//
//  ResortView.swift
//  SnowSeeker
//
//  Created by artembolotov on 24.07.2023.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort
    
    @Environment (\.horizontalSizeClass) var sizeClass
    @Environment (\.dynamicTypeSize) var typeSize
    
    @EnvironmentObject var favorites: Favorites
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        ZStack(alignment: .bottomTrailing) {
                            LinearGradient(stops: [
                                Gradient.Stop(color: .clear, location: 0.7),
                                Gradient.Stop(color: .black.opacity(0.3), location: 0.9)
                            ], startPoint: .top, endPoint: .bottom)
                            
                            Text(resort.imageCredit)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(4)
                                .padding(.trailing, 4)
                        }
                    }
                
                HStack {
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    
                    Button(favorites.containts(resort) ? "Remove from favorites" : "Add to favorites") {
                        if favorites.containts(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            .navigationTitle("\(resort.name), \(resort.country)")
            .navigationBarTitleDisplayMode(.inline)
            .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
            } message: { facility in
                Text(facility.description)
            }
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
        .environmentObject(Favorites())
    }
}
