//
//  Favorites.swift
//  SnowSeeker
//
//  Created by artembolotov on 31.07.2023.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let fileName = "Favorites.json"
    
    init() {
        do {
            let saveURL = FileManager.documentsDirectory.appendingPathComponent(fileName)
            let data = try Data(contentsOf: saveURL)
            resorts = try JSONDecoder().decode(Set<String>.self, from: data)
        } catch {
            resorts = []
        }
    }
    
    func containts(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(resorts)
            let saveURL = FileManager.documentsDirectory.appendingPathComponent(fileName)
            try encoded.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data. \(error.localizedDescription)")
        }
    }
}
