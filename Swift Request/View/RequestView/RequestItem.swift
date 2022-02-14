//
//  RequestItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

struct RequestItem<Label: View>: View {
    
    @ObservedObject var request: RequestEntity
    
    let label: Label
    
    init(request: RequestEntity, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.request = request
    }
    
    private var primaryColor: Color {
        if let method = MethodType.init(rawValue: request.method) {
            return method.color().primary
        } else {
            return Color.cyan
        }
    }
    
    private var secondaryColor: Color {
        if let method = MethodType.init(rawValue: request.method) {
            return method.color().secondary
        } else {
            return Color.cyan.opacity(0.15)
        }
    }
    
    private var fontSize: Font {
        if let method = MethodType.init(rawValue: request.method) {
            switch method {
            case .GET, .POST, .PUT, .HEAD:
                return .caption2
            case .PATCH, .DELETE, .OPTION:
                return .system(size: 10)
            }
        }
        return .caption2
    }
    
    var body: some View {
        
        let methodName: String = request.method.uppercased()
        let title = request.title
        let url = request.url
        let requestRunning = request.running
        
        VStack {
            HStack {
                ZStack {
                    Text(methodName)
                        .font(fontSize)
                        .bold()
                        .padding(5)
                        .foregroundColor(primaryColor)
                        .frame(width: 50, height: 25, alignment: .center)
                }
                .background(secondaryColor)
                .cornerRadius(10)
                VStack(alignment: .leading) {
                    
                    Text(title)
                    Text(url)
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                        .tint(Color.gray)
                }
                .clipped()
                Spacer()
                if requestRunning {
                    ProgressView()
                } else {
                    label
                }
            }
        }
    }
}

extension RequestItem where Label == EmptyView {
    init(request: RequestEntity) {
        self.init(request: request, label: {EmptyView()})
    }
}

//struct RequestItem_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestItem()
//    }
//}
