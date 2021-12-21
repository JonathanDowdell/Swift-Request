//
//  MethodType.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI

enum MethodType: String, CaseIterable {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTION
    
    func color() -> (primary: Color, secondary: Color) {
        switch self {
        case .GET:
            return (Color.cyan, Color.cyan.opacity(0.15))
        case .POST:
            return (Color.green, Color.green.opacity(0.15))
        case .PUT:
            return (Color.purple, Color.purple.opacity(0.15))
        case .PATCH:
            return (Color.orange, Color.orange.opacity(0.15))
        case .DELETE:
            return (Color.red, Color.red.opacity(0.15))
        case .HEAD:
            return (Color.indigo, Color.indigo.opacity(0.15))
        case .OPTION:
            return (Color.gray, Color.gray.opacity(0.15))
        }
    }
}
