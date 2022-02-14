//
//  ProjectView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/27/21.
//

import SwiftUI

struct ProjectView: View {
    
    @StateObject var vm: ProjectViewModel
    
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
        
        let orderedRequest: [RequestEntity] = vm.project.orderedRequest
        
        let editingMode = vm.isEditable ? Binding.constant(EditMode.active) : Binding.constant(EditMode.inactive)
        
        let editOrDoneText = vm.isEditable ? "Done" : "Edit"
        
        let playButtonIcon = !vm.runningSequentialRequest ? "play.fill" : "stop.fill"
        
        let playButtonColor = !vm.runningSequentialRequest ? Color.accentColor : Color.red
        
        List {
            
            let hasContent = orderedRequest.hasContent
            
            if hasContent {
                Section {
                    ForEach(orderedRequest, id: \.self) { request in
                        NavigationLink {
                            RunRequestView(vm: RunRequestViewModel(request: request, context: moc),
                                           requestsManager: ProjectViewModel(vm.project, context: moc))
                        } label: {
                            RequestItem(request: request) {
                                
                            }
                            .padding(.vertical, 8)
                        }
                        .disabled(vm.disableRunRequestView)
                        .disabled(vm.runningSequentialRequest)
                    }
                    .onMove(perform: vm.move)
                    .onDelete(perform: vm.delete)
                } header: {
                    HStack(spacing: 20) {
                        
                        Text("Request")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                vm.isEditable.toggle()
                            }
                        } label: {
                            Text(editOrDoneText)
                        }
                        
                        Button {
                            vm.runRequestSequentially()
                        } label: {
                            Image(systemName: playButtonIcon)
                        }
                        .foregroundColor(playButtonColor)
                        
                    }
                    .animation(.default, value: vm.runningSequentialRequest)
                    .id(vm.updateToken)
                }
            }
        }
        .environment(\.editMode, editingMode)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.shouldOpenProjectEditView = true
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .popover(isPresented: $vm.shouldOpenProjectEditView) {
            CreateProjectView(vm: CreateProjectViewModel(project: vm.project, moc: moc),
                              previousVm: MainViewModel(context: moc))
        }
        .onAppear {vm.updateToken = UUID()}
        .navigationTitle(vm.project.name)
    }
}

//struct ProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectView()
//    }
//}

