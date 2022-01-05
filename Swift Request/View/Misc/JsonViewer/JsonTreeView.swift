//
//  JsonTreeView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 1/3/22.
//

import SwiftUI

typealias KeyValuePair = (key: String, value: AnyHashable)

struct JsonTreeView: View {
    
    fileprivate let keyValuePairs: [KeyValuePair]
    
    init(_ dictionary: JsonObject) {
        self.keyValuePairs = dictionary.sorted(by: { obj1, obj2 in
            return obj1.key < obj2.key
        })
    }
    
    init(_ list: [JsonObject], key: String = "") {
        self.keyValuePairs = list.enumerated().map({ obj in
            return (key: "\(key)[\(obj.offset)]", value: obj.element)
        })
    }
    
    init(_ keyValuePairs: [KeyValuePair]) {
        self.keyValuePairs = keyValuePairs
    }
    
    var body: some View {
        ForEach(keyValuePairs.indices, id: \.self) { index in
            VStack(alignment: .leading) {
                if index > 0 {
                    Divider()
                }
                
                JsonItem(self.keyValuePairs[index])
            }
        }
    }
}

extension JsonTreeView {
    init(_ json: JsonStringValue, key: String = "") {
        switch json {
        case let list as [JsonObject]:
            self.init(list, key: key)
        case let dictionary as JsonObject:
            self.init(dictionary)
        default:
            self.init(JsonObject())
        }
    }
}

struct JsonTreeView_Previews: PreviewProvider {
    static var previews: some View {
        JsonTreeView(["hello":"world"])
    }
}

internal protocol JsonStringValue {
    var stringValue: String? { get }
}

extension JsonStringValue {
    var stringValue: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Array: JsonStringValue where Element: JsonStringValue {}

extension JsonObject: JsonStringValue {}
