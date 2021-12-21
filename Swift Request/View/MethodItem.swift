//
//  MethodItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI

struct MethodItem: View {
    var method: MethodType
    
    var body: some View {
        Text(method.rawValue)
            .font(.caption2)
            .bold()
            .padding(5)
            .foregroundColor(method.color().primary)
            .background(method.color().secondary)
            .cornerRadius(10)
    }
}


