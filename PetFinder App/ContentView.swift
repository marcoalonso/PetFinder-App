//
//  ContentView.swift
//  PetFinder App
//
//  Created by Marco Alonso Rodriguez on 26/01/24.
//

import SwiftUI

struct ContentView: View {
    let petfinderAPI = PetfinderAPI()
    
    @State private var animals: [Animal] = []
    
    var body: some View {
        VStack {
            Button("Obtener animales") {
                petfinderAPI.getAnimals { result in
                    switch result {
                    case .success(let animals):
                        self.animals = animals
                    case .failure(let error):
                        print("Error al obtener animales: \(error)")
                    }
                }
            }
            
            List(animals, id: \.id) { animal in
                VStack(alignment: .leading) {
                    Text("Nombre: \(animal.name)")
                        .font(.headline)
                    Text("Especie: \(animal.species)")
                        .font(.subheadline)
                    Text("Edad: \(animal.age)")
                        .font(.subheadline)
                }
            }
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
