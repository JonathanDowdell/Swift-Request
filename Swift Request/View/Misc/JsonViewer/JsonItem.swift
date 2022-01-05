//
//  JsonItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 1/3/22.
//

import SwiftUI

struct JsonItem: View {
    
    @State fileprivate var isOpen: Bool = false
    
    @State fileprivate var isRotate: Bool = false
    
    fileprivate let key: String
    
    fileprivate let value: AnyHashable
    
    
    init(_ keyValuePair: KeyValuePair) {
        self.key = keyValuePair.key
        self.value = keyValuePair.value
    }
    
    init(key: String, value: AnyHashable) {
        self.key = key
        self.value = value
    }
    
    fileprivate var mainDynamicView: some View {
        switch value {
        case let list as [JsonObject]:
            return AnyView(keyValuePairViewFactor(JsonTreeView(list, key: key)))
        case let array as [AnyHashable]:
            let array = array.enumerated().map { ["\($0.offset)": $0.element]}
            return AnyView(keyValuePairViewFactor(JsonTreeView(array, key: key)))
        case let dictionary as JsonObject:
            return AnyView(keyValuePairViewFactor(JsonTreeView(dictionary)))
        case let number as NSNumber:
            return AnyView(leafViewFactory(number.stringValue))
        case let string as String:
            return AnyView(leafViewFactory(string))
        default:
            return AnyView(leafViewFactory("null"))
        }
    }
    
    fileprivate func keyValuePairViewFactor(_ jsonTreeView: JsonTreeView) -> some View {
        VStack(alignment: .leading) {
            Button(action: toggle) {
                HStack(alignment: .center) {
                    Image(systemName: "arrowtriangle.right.fill")
                        .resizable()
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(Color.gray)
                        .rotationEffect(Angle(degrees: isRotate ? 90 : 0))
                    
                    Text(key)
                    Spacer()
                }
            }

            if isOpen {
                Divider()
                jsonTreeView
            }
        }
    }
    
    fileprivate func leafViewFactory(_ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center) {
                Text(key)
                Spacer()
            }
            
            Text(value.prefix(60))
                .lineSpacing(0)
                .foregroundColor(Color.gray)
        }
        .padding(.vertical, 5)
        .padding(.trailing, 10)
    }
    
    fileprivate func toggle() {
        self.isOpen.toggle()
        withAnimation(.linear(duration: 0.1)) {
            self.isRotate.toggle()
        }
    }
    
    
    var body: some View {
        mainDynamicView
            .padding(.leading, 10)
        
    }
}

struct JsonItem_Previews: PreviewProvider {
    static var previews: some View {
        JsonItem(KeyValuePair(key: "hello", value: "world"))
    }
}
