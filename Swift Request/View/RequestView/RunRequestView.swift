//
//  RunRequestView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

struct RunRequestView<RequestManager>: View where RequestManager: RequestsManagement {
    
    @StateObject var vm: RunRequestViewModel
    
    @StateObject var requestsManager: RequestManager
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {
        List {

            projectSection
            
            urlSection
            
            headerSection
            
            bodySection
            
            responseSection

            
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: runRequest) {
                    if vm.isSendingRequest {
                        ProgressView()
                    } else {
                        Image(systemName: "play.fill")
                    }
                }
                .accessibilityIdentifier("runRequestBtn")
            }
        }
        .navigationTitle("Run Request")
        .onDisappear {
            withAnimation {
                let shouldUpdate = vm.shouldUpdate
                if shouldUpdate {
                    vm.saveProject()
                    requestsManager.reload()
                }
            }
        }
    }
    
    private func runRequest() {
        vm.runRequest()
        requestsManager.reload()
    }
}

struct RunRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context = PersistenceController.shared.container.viewContext
            
            NavigationView {
                RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                    .environment(\.colorScheme, .light)
            }
            
            NavigationView {
                RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}


