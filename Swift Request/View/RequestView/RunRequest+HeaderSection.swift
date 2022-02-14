//
//  RunRequest+HeaderSection.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI

// MARK: Header
extension RunRequestView {
    
    var headerSection: some View {
        
        Section {
            
            let headerParams = vm.headerParams
            
            ForEach(headerParams, id: \.self) {
                ParamItem($0)
            }
            .onDelete(perform: vm.removeHeaderParam)
            
            Button(action: vm.addHeaderParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    
                    Spacer()
                    
                    Text("Add Header Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
            .accessibilityIdentifier("addUrlHeaderBtn")
            
        } header: {
            HStack {
                Text("Header")
            }
        }
    }
}

struct RunRequestView_HeaderSection_Previews: PreviewProvider {
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
