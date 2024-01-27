//
//  PetFinderApiClient.swift
//  PetFinder App
//
//  Created by Marco Alonso Rodriguez on 26/01/24.
// https://www.petfinder.com/developers/v2/docs/#get-animals

import Foundation


class PetfinderAPI {
    private let baseURL = "https://api.petfinder.com/v2"
    private var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "petfinder_token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "petfinder_token")
        }
    }

    // Función para obtener el token OAuth2
    func getToken(clientID: String, clientSecret: String, completion: @escaping (Result<String, Error>) -> Void) {
           // Si el token ya está guardado, lo devolvemos sin hacer una nueva solicitud
           if let savedToken = token {
               completion(.success(savedToken))
               return
           }
           
           let urlString = "https://api.petfinder.com/v2/oauth2/token"
           let params = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
           guard let url = URL(string: urlString) else {
               completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
               return
           }
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.httpBody = params.data(using: .utf8)
           
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                   return
               }
               
               do {
                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let accessToken = json["access_token"] as? String {
                       self.token = accessToken
                       completion(.success(accessToken))
                   } else {
                       completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])) )
                   }
               } catch {
                   completion(.failure(error))
               }
           }
           task.resume()
       }

    // Función para obtener animales
    func getAnimals(completion: @escaping (Result<[Animal], Error>) -> Void) {
            guard let token = self.token else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token not available"])))
                return
            }
            
            let urlString = "\(baseURL)/animals&size=large"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(PetfinderResponse.self, from: data)
                    completion(.success(response.animals))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    func getAnimalTypes(completion: @escaping (Result<[String], Error>) -> Void) {
            guard let token = self.token else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token not available"])))
                return
            }
            
            let urlString = "\(baseURL)/types"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let types = json["types"] as? [[String: Any]] {
                        let typeNames = types.compactMap { $0["name"] as? String }
                        completion(.success(typeNames))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])) )
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}
