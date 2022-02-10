//
//  StatusCodeItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/7/22.
//

import SwiftUI

struct StatusCodeItem: View {
    
    var statusCode: Int64
    
    var statusColor: (primary:Color, secondary: Color) {
        switch statusCode {
        case 200 ... 299:
            return (Color.green, Color.green.opacity(0.15))
        case 300 ... 499:
            return (Color.red, Color.red.opacity(0.15))
        default:
            return (Color.green, Color.green.opacity(0.15))
        }
    }
    
    var body: some View {
        Text("\(statusCode)")
            .font(.caption2)
            .bold()
            .padding(5)
            .foregroundColor(statusColor.primary)
            .background(statusColor.secondary)
            .cornerRadius(10)
    }
}
