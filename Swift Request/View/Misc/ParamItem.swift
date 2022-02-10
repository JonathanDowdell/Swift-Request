//
//  ParamItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/20/21.
//

import SwiftUI

struct ParamItem: View {
    
    private var queryParamEntity: ParamEntity
    
    @State private var active: Bool
    
    @Environment(\.managedObjectContext) var moc
    
    init(_ queryParam: ParamEntity) {
        self.queryParamEntity = queryParam
        self.active = queryParam.active
    }
    
    private var key: Binding<String> {
        .init {
            return queryParamEntity.key
        } set: { newValue in
            queryParamEntity.key = newValue
        }
    }
    
    private var value: Binding<String> {
        .init {
            return queryParamEntity.value
        } set: { newValue in
            queryParamEntity.value = newValue
        }
    }
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    queryParamEntity.active.toggle()
                    active.toggle()
                }
            } label: {
                Image(systemName: active ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .padding(.trailing)
            .accessibilityIdentifier("paramToggleButton")
            
            Spacer()
            TextField("key", text: key)
                .multilineTextAlignment(.leading)
                .autocapitalization(.none)
                .accessibilityIdentifier("paramKeyTextField")
            TextField("value", text: value)
                .multilineTextAlignment(.trailing)
                .padding(.trailing, 10)
                .autocapitalization(.none)
                .accessibilityIdentifier("paramValueTextField")
        }
    }
}

//struct QueryParamItem_Previews: PreviewProvider {
//    static var previews: some View {
//        QueryParamItem(queryParam: <#QueryParamEntity#>)
//    }
//}
