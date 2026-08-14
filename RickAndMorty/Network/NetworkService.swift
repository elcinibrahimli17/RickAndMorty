//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Elchın on 12.08.26.
//

import UIKit

final class NetworkService {
    
    func getData<T: Decodable>(urlString: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            if let httpURLResponse = response as? HTTPURLResponse {
                if httpURLResponse.statusCode == 200 {
                    self.decode(data: data, completion: completion)
                } else if httpURLResponse.statusCode == 400 {
                    completion(.failure(.badRequest))
                } else if httpURLResponse.statusCode == 401 {
                    completion(.failure(.unauthorized))
                } else if httpURLResponse.statusCode == 404 {
                    completion(.failure(.notFound))
                } else if httpURLResponse.statusCode == 500 {
                    completion(.failure(.serverError))
                } else {
                    let unknownError = NSError(domain: "Unknown status code: \(httpURLResponse.statusCode)", code: httpURLResponse.statusCode)
                    completion(.failure(.custom(unknownError)))
                }
            }
        }
        .resume()
    }
    
    private func decode<T: Decodable>(data: Data?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let data else {
            completion(.failure(.badData))
            return
        }
        
        do {
            let decode = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decode))
        } catch {
            print("Decode xətası: \(error)")
            completion(.failure(.badParsing))
        }
    }
    
    private func encode(body: Encodable) -> Data {
        do {
            let encode = try JSONEncoder().encode(body)
            return encode
        } catch {
            print(error)
        }
        
        return Data()
    }
}
