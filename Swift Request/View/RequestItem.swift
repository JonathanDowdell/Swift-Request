//
//  RequestItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

struct RequestItem<Label: View>: View {
    
    var request: RequestEntity
    let label: Label
    
    init(request: RequestEntity, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.request = request
    }
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Text(request.wrappedMethod.uppercased())
                        .font(.caption2)
                        .bold()
                        .padding(5)
                        .foregroundColor(Color.cyan)
                }
                .background(Color.cyan.opacity(0.15))
                .cornerRadius(10)
                VStack(alignment: .leading) {
                    Text(request.wrappedTitle)
                    Text(request.wrappedURL)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .tint(Color.gray)
                }
                
                label
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
