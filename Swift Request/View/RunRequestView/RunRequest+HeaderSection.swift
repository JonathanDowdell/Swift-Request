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
            ForEach(vm.headerParams, id: \.self) {
                ParamItem($0)
            }
            .onDelete(perform: removeHeaderParam)
            
            Button(action: addHeaderParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    
                    Spacer()
                    
                    Text("Add Header Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
            
        } header: {
            HStack {
                Text("Header")
            }
        }
    }
    
    private func addHeaderParam() {
        let queryParam = ParamEntity(context: moc)
        queryParam.type = ParamType.Header.rawValue
        queryParam.active = true
        withAnimation {
            vm.headerParams.append(queryParam)
        }
    }
    
    private func removeHeaderParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        vm.headerParams.remove(at: element)
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
