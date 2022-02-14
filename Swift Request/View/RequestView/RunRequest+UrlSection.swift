//
//  RunRequest+UrlSection.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI

// MARK: URL Section
extension RunRequestView {
    
    var urlSection: some View {
        Section {
            
            let title = $vm.title
            
            let url = $vm.url
            
            let methodType = $vm.methodType
            
            let params = vm.urlParams
            
            HStack {
                
                let titleIconColor: Color = vm.title.isEmpty ? Color.gray : Color.accentColor
                
                Image(systemName: "pencil")
                    .padding(.trailing, 18)
                    .foregroundColor(titleIconColor)
                Text("Title")
                    .foregroundColor(Color.gray)
                Spacer()
                TextField("Optional", text: title)
                    .multilineTextAlignment(.trailing)
                    .disableAutocorrection(true)
                    .padding(.trailing, 10)
                    .accessibilityIdentifier("titleTextField")
            }
            
            HStack {
                
                let urlIconColor: Color = vm.url.isEmpty ? Color.gray : Color.accentColor
                
                Image(systemName: "personalhotspot")
                    .padding(.trailing, 10)
                    .foregroundColor(urlIconColor)
                Text("URL")
                    .foregroundColor(Color.gray)
                Spacer()
                TextField("Localhost:3000", text: url)
                    .multilineTextAlignment(.trailing)
                    .disableAutocorrection(true)
                    .padding(.trailing, 10)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("urlTextField")
            }
            
            Picker(selection: methodType) {
                ForEach(MethodType.allCases, id: \.self) {
                    MethodItem(method: $0)
                }
            } label: {
                HStack {
                    Image(systemName: "bolt.horizontal")
                        .padding(.trailing, 10)
                        .foregroundColor(Color.accentColor)
                    Text("Method")
                        .foregroundColor(.gray)
                }
            }
            .accessibilityIdentifier("methodTypePicker")
            .onAppear {
                vm.shouldUpdate = true
            }
            .onDisappear {
                vm.shouldUpdate = false
            }
            
            ForEach(params, id: \.self) {
                ParamItem($0)
            }
            .onDelete(perform: vm.removeURLQueryParam)
            
            Button(action: vm.addURLQueryParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    
                    Spacer()
                    
                    Text("Add URL Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
            .accessibilityIdentifier("addUrlParamBtn")
        } header: {
            Text("URL")
        }
    }
}

struct RunRequestView_UrlSection_Previews: PreviewProvider {
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
