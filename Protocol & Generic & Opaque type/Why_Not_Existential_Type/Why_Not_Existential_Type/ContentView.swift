//
//  ContentView.swift
//  Why_Not_Existential_Type
//
//  Created by Seungjun Lee on 8/28/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

@Model
class User {
    init() { }
}

class Container {
    
    func insert<T>(_ model: T) where T : PersistentModel {
        
    }
    
    func insert(_ model: any PersistentModel) {
        
    }
    
    protocol BirdWithoutAssociatedType {
        
    }
    
    func insert<T>(_ models: [T]) where T : BirdWithoutAssociatedType {
        
    }
    
    func insert(_ models: BirdWithoutAssociatedType) {
        
    }
    
    protocol BirdWithAssociatedType {
        associatedtype Content
    }
    
    func insert<T>(_ models: [T]) where T : BirdWithAssociatedType {
        
    }
    
    func insert(_ models: any BirdWithAssociatedType) {
        
    }
}


