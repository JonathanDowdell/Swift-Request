//
//  BodyType.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI

enum BodyType: String, CaseIterable {
    case FormURLEncoded = "Form URL Encoded"
    case MultipartFormData = "Multipart Form Data"
    case JSON = "JSON"
    case XML = "XML"
    case Raw = "Raw"
    case Binary = "Binary"
    
    func color() -> (primary: Color, secondary: Color) {
        switch self {
        case .FormURLEncoded:
            return (Color.green, Color.green.opacity(0.15))
        case .MultipartFormData:
            return (Color.pink, Color.pink.opacity(0.15))
        case .JSON:
            return (Color.mint, Color.mint.opacity(0.15))
        case .XML:
            return (Color.cyan, Color.cyan.opacity(0.15))
        case .Raw:
            return (Color.indigo, Color.indigo.opacity(0.15))
        case .Binary:
            return (Color.orange, Color.orange.opacity(0.15))
        }
    }
}
