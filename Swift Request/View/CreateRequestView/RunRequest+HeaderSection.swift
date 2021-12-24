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
            ForEach(viewModel.headerParams, id: \.self) {
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
            viewModel.headerParams.append(queryParam)
        }
    }
    
    private func removeHeaderParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        viewModel.headerParams.remove(at: element)
    }
}

struct CreateRequest_HeaderSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RunRequestView(viewModel: RunRequestViewModel(historyUpdateId: .constant(UUID())))
                .environment(\.colorScheme, .light)
            
            RunRequestView(viewModel: RunRequestViewModel(historyUpdateId: .constant(UUID())))
                .environment(\.colorScheme, .dark)
        }
    }
}
