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
            HStack {
                Image(systemName: "pencil")
                    .padding(.trailing, 18)
                    .foregroundColor(vm.title.isEmpty ? Color.gray : Color.accentColor)
                Text("Title")
                    .foregroundColor(Color.gray)
                Spacer()
                TextField("Optional", text: $vm.title)
                    .multilineTextAlignment(.trailing)
                    .disableAutocorrection(true)
                    .padding(.trailing, 10)
                    .accessibilityIdentifier("titleTextField")
            }
            HStack {
                Image(systemName: "personalhotspot")
                    .padding(.trailing, 10)
                    .foregroundColor(vm.url.isEmpty ? Color.gray : Color.accentColor)
                Text("URL")
                    .foregroundColor(Color.gray)
                Spacer()
                TextField("Localhost:3000", text: $vm.url)
                    .multilineTextAlignment(.trailing)
                    .disableAutocorrection(true)
                    .padding(.trailing, 10)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("urlTextField")
            }
            Picker(selection: $vm.methodType) {
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
            
            ForEach(vm.urlParams, id: \.self) {
                ParamItem($0)
            }
            .onDelete(perform: removeURLQueryParam)
            
            Button(action: addURLQueryParam) {
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
    
    private func addURLQueryParam() {
        let queryParam = ParamEntity(context: moc)
        queryParam.raw_type = ParamType.URL.rawValue
        queryParam.active = true
        withAnimation {
            vm.urlParams.append(queryParam)
        }
    }
    
    private func removeURLQueryParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        vm.urlParams.remove(at: element)
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