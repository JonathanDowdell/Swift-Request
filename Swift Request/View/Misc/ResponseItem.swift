//
//  ResponseItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/10/22.
//

import SwiftUI

struct ResponseItem: View {
    
    let response: ResponseEntity
    
    private let dateFormatter = DateFormatter()
    
    private var systemImage: Image {
        switch response.statusCode {
        case 200 ... 299:
            return Image(systemName: "arrow.down.left.circle")
        case 300 ... 399:
            return Image(systemName: "circle")
        default:
            return Image(systemName: "circle.slash")
        }
    }
    
    var body: some View {
        HStack {
            systemImage
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(date(response.creationDate))
                    .foregroundColor(.primary)
                Text(time(response.creationDate))
                    .font(.caption)
            }
            .padding(.leading, 15)
            Spacer()
            
            StatusCodeItem(statusCode: response.statusCode)
        }
    }
    
    func date(_ date: Date) -> String {
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func time(_ date: Date) -> String {
        dateFormatter.dateFormat = "h:mm:ss a"
        return dateFormatter.string(from: date)
    }
}
