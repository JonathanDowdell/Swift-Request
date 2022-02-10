//
//  ResponseListView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/10/22.
//

import SwiftUI

struct ResponseListView<ViewModel: ResponseProtocol>: View {
    
    @StateObject var vm: ViewModel
    
    var responses: [ResponseEntity] {
        vm.responses.sorted(by: { $0.creationDate > $1.creationDate })
    }
    
    var body: some View {
        List {
            if responses.hasContent {
                ForEach(responses, id: \.self) { response in
                    NavigationLink {
                        ResponseView(response: response)
                    } label: {
                        ResponseItem(response: response)
                            .padding(.vertical, 5)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let response = self.responses[index]
                        vm.removeResponse(response)
                    }
                }
            } else {
                Text("Empty List")
            }
        }
        .navigationBarTitle("Responses")
    }
}

struct ResponseListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let context = PersistenceController.shared.container.viewContext
            ResponseListView(vm: RunRequestViewModel(context: context))
        }
    }
}
