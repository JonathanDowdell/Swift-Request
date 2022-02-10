//
//  RequestLoader.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/31/21.
//

import Foundation
import SwiftUI
import CoreData

enum NetworkError: Error {
    case badUrl
}

struct RequestLoader {
    var session = URLSession.shared
    var decoder = JSONDecoder()
    var request: RequestEntity
    var context: NSManagedObjectContext
    
    func load(completion: @escaping (Result<ResponseDataPackage, NetworkError>) -> Void) {
        
        // Running
        request.running.toggle()
        
        // URL
        guard let url = URL(string: request.url) else {
            return completion(.failure(.badUrl))
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = getUrlQueryItems()
        
        guard let finalUrl = urlComponents?.url else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url: finalUrl)
        
        request.httpMethod = self.request.method
        
        // Header
        request.addValue(getContentType(), forHTTPHeaderField: "Content-Type")
        let headerParams = self.request.params
            .filter { ($0.type == .Header) && $0.active }
        headerParams.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Body
        if self.request.contentType == .FormURLEncoded {
            request.httpBody = getFormUrlEncodedParam()
        }
        
        if self.request.contentType == .MultipartFormData {
            let boundary = "Boundary-\(UUID().uuidString)"
            
            let multipartFormData = getMultipartFormDataParam(boundary: boundary)?.data(using: .utf8)
            request.allHTTPHeaderFields?.removeValue(forKey: "Content-Type")
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = multipartFormData
        }
        
        let methodStart = Date()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let methodFinish = Date()
            let executionTime = (methodFinish.timeIntervalSince(methodStart) * 1000).rounded()
            print("Execution time: \(executionTime)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.request.running.toggle()
                let responseDataPackage = ResponseDataPackage(response: response, responseTime: Int(executionTime), data: data)
                completion(.success(responseDataPackage))
            }
        }
        
        
        task.resume()
    }
    
    func getContentType() -> String {
        switch request.contentType {
        case .FormURLEncoded:
            return "application/x-www-form-urlencoded"
        case .JSON:
            return "application/json"
        case .XML:
            return "application/xml"
        case .Raw:
            return "text/plain"
        case .Binary:
            return "text/plain"
        case .MultipartFormData:
            return "multipart/form-data; boundary="
        }
    }
    
    func getUrlQueryItems() -> [URLQueryItem] {
        return self.request.params
            .filter { ($0.type == .URL) && $0.active }
            .map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    func getFormUrlEncodedParam() -> Data? {
        let bodyParams = self.request.params
            .filter { ($0.type == .Body) && $0.active }
        
        guard bodyParams.hasContent else {
            return nil
        }
        
        var dictionary = [String: Any]()
        bodyParams.forEach { dictionary[$0.key] = $0.value }
        let jsonString = dictionary.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: false)
    }
    
    func getMultipartFormDataParam(boundary: String) -> String? {
        let bodyParams = self.request.params
            .filter { ($0.type == .Body) && $0.active }
        
        let parameters: [[String : Any]] = bodyParams.map { ["key": $0.key, "value":$0.value, "type": "text"] }
        
        var body = ""
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                if param["contentType"] != nil {
                    body += "\r\nContent-Type: \(param["contentType"] as! String)"
                }
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    guard let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data else { return nil }
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n"
        return body
    }
}

func measureInMilliseconds(_ block: () -> ()) -> UInt64 {
    let start = DispatchTime.now()
    block()
    let end = DispatchTime.now()

    // Difference in nano seconds (UInt64)
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    
    // Technically could overflow for long running tests
    let timeInterval = nanoTime / 1_000_000
    return timeInterval
}
