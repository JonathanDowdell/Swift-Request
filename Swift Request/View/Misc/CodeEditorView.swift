//
//  CodeEditorView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/11/22.
//

import SwiftUI
import CodeViewer

struct CodeEditorView: View {
    
    @Binding var content: String
    
    let mode: CodeWebView.Mode
    
    var body: some View {
        List {
            CodeViewer(content: $content,
                       mode: mode,
                       darkTheme: .clouds_midnight,
                       lightTheme: .merbivore,
                       isReadOnly: false, fontSize: 54)
                .frame(minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
        }
        .navigationTitle("\(mode.rawValue.uppercased()) Editor")
    }
}

//struct JSONEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        CodeEditorView(content: <#Binding<String>#>)
//    }
//}
