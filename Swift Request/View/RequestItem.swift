//
//  RequestItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

struct RequestItem: View {
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Text("POST")
                        .font(.caption2)
                        .bold()
                        .padding(5)
                        .foregroundColor(Color.cyan)
                }
                .background(Color.cyan.opacity(0.15))
                .cornerRadius(10)
                VStack(alignment: .leading) {
                    Text("Http GET")
                    Text("https://httpbin.org/post")
                        .font(.footnote)
                        .tint(Color.gray)
                }
            }
        }
    }
}


struct RequestItem_Previews: PreviewProvider {
    static var previews: some View {
        RequestItem()
    }
}
