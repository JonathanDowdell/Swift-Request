//
//  JsonViewer.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 1/3/22.
//

import SwiftUI

typealias JsonObject = [String: AnyHashable]

struct JsonViewer: View {
    
    fileprivate let rootJsonObjectDictionary: JsonObject
    
    fileprivate let rootJsonObjectList: [JsonObject]?
    
    init(_ dictionary: JsonObject) {
        self.rootJsonObjectList = nil
        self.rootJsonObjectDictionary = dictionary
    }
    
    init(_ list: [JsonObject]) {
        self.rootJsonObjectList = list
        self.rootJsonObjectDictionary = JsonObject()
    }
    
    init(_ url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            self.rootJsonObjectList = jsonData as? [JsonObject]
            self.rootJsonObjectDictionary = jsonData as? JsonObject ?? JsonObject()
        } catch {
            self.rootJsonObjectList = nil
            self.rootJsonObjectDictionary = JsonObject()
            print("JSONView error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            JsonTreeView(rootJsonObjectList ?? rootJsonObjectDictionary )
        }
    }
}

struct JsonViewer_Previews: PreviewProvider {
    static var previews: some View {
        JsonViewer(["hello":"world"])
    }
}
