//
//  ResponseView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/10/22.
//

import SwiftUI

struct ResponseView: View {
    
    let response: ResponseEntity
    
    private var title: String {
        response.request?.title ?? "Unamed"
    }
    
    private var url: String {
        response.url.replacingOccurrences(of: "?", with: "")
    }
    
    private var statusCode: String {
        "\(response.statusCode)"
    }
    
    
    var body: some View {
        List {
            Section("General") {
                HStack {
                    Text("Name")
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text(title)
                }
            }
            
            Section("Network") {
                HStack {
                    Text("URL")
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text(url)
                }
                
                HStack {
                    Text("Status Code")
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    StatusCodeItem(statusCode: response.statusCode)
                }
                
                HStack {
                    Text("Response Time")
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text("\(response.responseTime) ms")
                }
            }
            
            Section("Headers") {
                ForEach(response.headers.sorted(by: { $0.key < $1.key }), id: \.self) { header in
                    if let headerParam = header as ParamEntity {
                        HStack {
                            Text(headerParam.key)
                                .foregroundColor(.accentColor)

                            Spacer()

                            Text(headerParam.value)
                                .textSelection(.enabled)
                        }

                    }
                }
            }
        }
        .navigationBarTitle("Response")
    }
}
