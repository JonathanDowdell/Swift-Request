//
//  ParamType.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/22/21.
//

import Foundation

enum ParamType: String, CaseIterable {
case URL, Header, Body, Response
    init(_ rawValue: String) {
        switch rawValue {
        case "URL": self = .URL
        case "Header": self = .Header
        case "Body": self = .Body
        case "Response": self = .Response
        default: self = .Body
        }
    }
}
