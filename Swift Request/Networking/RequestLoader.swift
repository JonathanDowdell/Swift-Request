//
//  RequestLoader.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/31/21.
//

import Foundation

struct RequestLoader {
    var session = URLSession.shared
    var decoder = JSONDecoder()
    var request: RequestEntity
    
    func load(completion: @escaping (Bool) -> Void) {
        request.running.toggle()
        guard let url = URL(string: request.wrappedURL) else {
            return completion(false)
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Unknown")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.request.running.toggle()
                completion(true)
            }
        }
        
        task.resume()
    }
}
