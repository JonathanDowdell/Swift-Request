//
//  KeyboardToolBar.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 1/1/22.
//

import SwiftUI

struct KeyboardToolBar: View {
    var body: some View {
        HStack(spacing: 20) {
            Button {
                print("Clicked")
            } label: {
                Image(systemName: "arrow.right")
            }
            .font(.caption2)
//                                Button {
//                                    print("Clicked")
//                                } label: {
//                                    Text("{ }")
//                                }
            Button {
                print("Clicked")
            } label: {
                Text("{")
            }
            Button {
                print("Clicked")
            } label: {
                Text("}")
            }
//                                Button {
//                                    print("Clicked")
//                                } label: {
//                                    Text("[ ]")
//                                }
            Button {
                print("Clicked")
            } label: {
                Text("[")
            }
            Button {
                print("Clicked")
            } label: {
                Text("]")
            }
            Button {
                print("Clicked")
            } label: {
                Text(":")
            }
            Button {
                print("Clicked")
            } label: {
                Text("\"")
            }
            Button {
                print("Clicked")
            } label: {
                Text(",")
            }
        }
    }
}

struct KeyboardToolBar_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardToolBar()
    }
}
