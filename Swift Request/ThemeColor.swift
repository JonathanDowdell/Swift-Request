//
//  ThemeColor.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/15/22.
//

import Foundation
import SwiftUI

class ThemeColor: ObservableObject {
    
    private let userDefault = UserDefaults.standard
    
    @Published var value: SystemColorValue = .System {
        didSet { didSetValue() }
    }
    
    var themes: [SystemColorValue] = [
        .System,
        .Dark,
        .Light
    ]
    
    init() {
        let index = userDefault.integer(forKey: "ThemeColor")
        userDefault.synchronize()
        switch index {
        case 0:
            value = .System
        case 1:
            value = .Light
        case 2:
            value = .Dark
        default:
            value = .Dark
        }
    }
    
    func colorScheme() -> ColorScheme {
        switch value {
        case .System:
            return getSystemColor()
        case .Light:
            return .light
        case .Dark:
            return .dark
        }
    }
    
    private func didSetValue() {
        userDefault.synchronize()
        switch value {
        case .System:
            userDefault.set(0, forKey: "ThemeColor")
        case .Light:
            userDefault.set(1, forKey: "ThemeColor")
        case .Dark:
            userDefault.set(2, forKey: "ThemeColor")
        }
        userDefault.synchronize()
    }
    
    private func getSystemColor() -> ColorScheme {
        let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
        switch currentSystemScheme {
        case .unspecified:
            return .light
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }
}
