//
//  PillButton.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/22/21.
//

import SwiftUI

struct PillButton<Content: View>: View {
    
    var content: Content
    
    var action: () -> Void
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) {
            content
                .padding(9)
                .background(Color.accentColor.opacity(0.15))
                .cornerRadius(10)
        }
    }
}

struct PillButton_Previews: PreviewProvider {
    static var previews: some View {
        PillButton {
            
        } content: {
            Text("Save")
                .font(.caption)
                .bold()
                .foregroundColor(.accentColor)
        }
    }
}
