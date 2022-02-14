//
//  CodeEditor.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/10/22.
//

import SwiftUI
import CodeViewer

struct CodeEditor: View {
    
    @State private var json = "{ \"hello\": \"world\" }"
    
    var body: some View {
        CodeViewer(content: $json, mode: .json, darkTheme: .clouds_midnight, lightTheme: .merbivore, isReadOnly: false, fontSize: 54)
            .frame(width: 400, height: 300, alignment: .center)
    }
}

struct CodeEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CodeEditor()
            CodeEditor()
                .preferredColorScheme(.dark)
                
        }
    }
}
