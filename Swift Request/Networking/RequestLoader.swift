//
//  RequestLoader.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/31/21.
//

import Foundation
import SwiftUI

struct RequestLoader {
    var session = URLSession.shared
    var decoder = JSONDecoder()
    var request: RequestEntity
    
    func load(completion: @escaping (Bool) -> Void) {
        request.running.toggle()
        // URL
        guard let url = URL(string: request.wrappedURL) else {
            return completion(false)
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = getUrlQueryItems()
        
        guard let finalUrl = urlComponents?.url else {
            return completion(false)
        }
        
        var request = URLRequest(url: finalUrl)
        
        request.httpMethod = self.request.wrappedMethod
        
        // Header
        request.addValue(getContentType(), forHTTPHeaderField: "Content-Type")
        let headerParams = self.request.wrappedParams
            .filter { ($0.wrappedType == .Header) && $0.active }
        headerParams.forEach { request.addValue($0.wrappedValue, forHTTPHeaderField: $0.wrappedKey) }
        
        // Body
        if self.request.wrappedContentType == .FormURLEncoded {
            request.httpBody = getFormUrlEncodedParam()
        }
        
        if self.request.wrappedContentType == .MultipartFormData {
            let boundary = "Boundary-\(UUID().uuidString)"
            
            let multipartFormData = getMultipartFormDataParam(boundary: boundary)?.data(using: .utf8)
            request.allHTTPHeaderFields?.removeValue(forKey: "Content-Type")
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = multipartFormData
        }
        
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
    
    func getContentType() -> String {
        switch request.wrappedContentType {
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
        return self.request.wrappedParams
            .filter { ($0.wrappedType == .URL) && $0.active }
            .map { URLQueryItem(name: $0.wrappedKey, value: $0.wrappedValue) }
    }
    
    func getFormUrlEncodedParam() -> Data? {
        let bodyParams = self.request.wrappedParams
            .filter { ($0.wrappedType == .Body) && $0.active }
        
        guard bodyParams.hasContent else {
            return nil
        }
        
        var dictionary = [String: Any]()
        bodyParams.forEach { dictionary[$0.wrappedKey] = $0.wrappedValue }
        let jsonString = dictionary.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        return jsonString.data(using: .utf8, allowLossyConversion: false)
    }
    
    func getMultipartFormDataParam(boundary: String) -> String? {
        let bodyParams = self.request.wrappedParams
            .filter { ($0.wrappedType == .Body) && $0.active }
        
        let parameters: [[String : Any]] = bodyParams.map { ["key": $0.wrappedKey, "value":$0.wrappedValue, "type": "text"] }
        
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
