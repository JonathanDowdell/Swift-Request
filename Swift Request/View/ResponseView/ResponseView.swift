//
//  ResponseView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/10/22.
//

import SwiftUI
import CodeViewer

enum ContentFileType: CaseIterable {
    case json, xml, text
    
    func value() -> (mode: CodeWebView.Mode, primaryColor: Color, secondaryColor: Color) {
        switch self {
        case .json:
            return (.json, Color.blue, Color.blue.opacity(0.15))
        case .xml:
            return (.xml, Color.green, Color.green.opacity(0.15))
        case .text:
            return (.text, Color.indigo, Color.indigo.opacity(0.15))
        }
    }
}

struct ResponseView: View {
    
    let response: ResponseEntity
    
    @State private var show = false
    
    private var title: String {
        response.request?.title ?? "Unamed"
    }
    
    private var url: String {
        response.url.replacingOccurrences(of: "?", with: "")
    }
    
    private var statusCode: String {
        "\(response.statusCode)"
    }
    
    private var content: Binding<String> {
        return .init {
            if let data = response.body {
                return String(decoding: data, as: UTF8.self)
            } else {
                return ""
            }
        } set: { newValue in }
    }
    
    @State private var selectedIndex = 0
    
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
            
            Section("Content") {
                let codeViewOpacity = show ? 1 : 0.0004
                let codeViewMode = ContentFileType.allCases[selectedIndex].value().mode
                CodeViewer(content: content,
                           mode: codeViewMode,
                           darkTheme: .clouds_midnight,
                           lightTheme: .merbivore,
                           isReadOnly: true, fontSize: 54)
                    .frame(minHeight: 100, idealHeight: 150, maxHeight: 150)
                    .opacity(codeViewOpacity)
                    .id(selectedIndex)
                
                Picker(selection: $selectedIndex) {
                    ForEach(0 ..< ContentFileType.allCases.count, id: \.self) {
                        let codeViewFileType = ContentFileType.allCases[$0].value()
                        Text(codeViewFileType.mode.rawValue.uppercased())
                            .font(.caption2)
                            .bold()
                            .padding(5)
                            .foregroundColor(codeViewFileType.primaryColor)
                            .background(codeViewFileType.secondaryColor)
                            .cornerRadius(10)
                    }
                } label: {
                    Text("File Type")
                }

                NavigationLink {
                    EmptyView()
                } label: {
                    Text("Full Screen")
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
                let headers = response.headers.sorted(by: { $0.key < $1.key })
                ForEach(headers, id: \.self) { header in
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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    show = true
                }
            }
        }
        .navigationBarTitle("Response")
    }
}
