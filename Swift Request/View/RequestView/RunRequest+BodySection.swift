//
//  RunRequest+BodySection.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI
import CodeViewer

extension RunRequestView {
    
    private var formURLEncodedAndMultiPartFormSection: some View {
        ForEach(vm.bodyQueryParams, id: \.self) {
            ParamItem($0)
        }
        .onDelete(perform: vm.removeBodyParam)
    }
    
    private var jsonSection: some View {
        NavigationLink {
            CodeEditorView(content: $vm.json, mode: .json)
        } label: {
            
            let curlyBracesColor: Color = vm.json.isEmpty ? .gray : .accentColor
            
            HStack {
                Image(systemName: "curlybraces")
                    .foregroundColor(curlyBracesColor)
                    .padding(.trailing, 15)
                Text("Modify JSON")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    private var xmlSection: some View {
        NavigationLink {
            CodeEditorView(content: $vm.xml, mode: .xml)
        } label: {
            
            let curlyBracesColor: Color = vm.xml.isEmpty ? .gray : .accentColor
            
            HStack {
                Image(systemName: "curlybraces")
                    .foregroundColor(curlyBracesColor)
                    .padding(.trailing, 15)
                Text("Modify XML")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    private var rawSection: some View {
        NavigationLink {
            CodeEditorView(content: $vm.text, mode: .text)
        } label: {
            HStack {
                
                let curlyBracesColor: Color = vm.text.isEmpty ? .gray : .accentColor
                
                Image(systemName: "curlybraces")
                    .foregroundColor(curlyBracesColor)
                    .padding(.trailing, 15)
                Text("Modify Text")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    

    
    var bodySection: some View {
        Section {
            
            let bodyContentTypeSelection = $vm.bodyContentType
            let bodyTypes: [BodyType] = BodyType.allCases
            
            Picker(selection: bodyContentTypeSelection) {
                ForEach(bodyTypes, id: \.self) {
                    
                    let method = $0
                    let primaryColor: Color = method.color().primary
                    let secondaryColor: Color = method.color().secondary
                    
                    Text(method.rawValue)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .padding(.horizontal, 3)
                        .foregroundColor(primaryColor)
                        .background(secondaryColor)
                        .cornerRadius(10)
                }
            } label: {
                
                let active = (!vm.bodyQueryParams.isEmpty)
                let shippingBoxColor: Color = active ? Color.accentColor : Color.gray
                
                HStack {
                    Image(systemName: "shippingbox")
                        .padding(.trailing, 14)
                        .foregroundColor(shippingBoxColor)
                    Text("Content")
                        .foregroundColor(.gray)
                }
            }
            
            switch vm.bodyContentType {
            case .FormURLEncoded, .MultipartFormData:
                formURLEncodedAndMultiPartFormSection
            case .JSON:
                jsonSection
            case .XML:
                xmlSection
            case .Binary:
                Text("Binary")
            case .Raw:
                rawSection
            }
            
            let isMultiPartFormDataOrFormURLEncoded = vm.bodyContentType == .FormURLEncoded || vm.bodyContentType == .MultipartFormData
            
            if isMultiPartFormDataOrFormURLEncoded {
                Button(action: vm.addBodyParam) {
                    
                    let bodyContentTypeText = vm.bodyContentType.rawValue
                    let bodyContentTypeIconColor = bodyContentTypeText.isEmpty ? Color.gray : Color.accentColor
                    
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(bodyContentTypeIconColor)
                        Spacer()
                        Text("Add \(bodyContentTypeText) Param")
                    }
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
                }
            }
            
        } header: {
            Text("Body")
        }
    }
    
}

struct RunRequestView_BodyContentSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context = PersistenceController.shared.container.viewContext
            
            RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                .environment(\.colorScheme, .light)
            
            RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                .environment(\.colorScheme, .dark)
        }
    }
}
