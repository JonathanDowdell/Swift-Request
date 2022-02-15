//
//  AccentColor.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/14/22.
//

import Foundation
import SwiftUI

class AccentColor: ObservableObject {
    
    static let shared = AccentColor()
    
    @Published var value: Color = .red
    
    private let defaults = UserDefaults.standard
    
    init() {
        let red = defaults.double(forKey: "RColor")
        let green = defaults.double(forKey: "GColor")
        let blue = defaults.double(forKey: "BColor")
        
        value = Color(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
    
    func setColor(_ color: Color) {
        defaults.set(color.components.red, forKey: "RColor")
        defaults.set(color.components.green, forKey: "GColor")
        defaults.set(color.components.blue, forKey: "BColor")
        value = color
    }
    
}

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}
