//
//  CreateProjectViewAlt.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/23/21.
//

import SwiftUI

struct CreateProjectView: View {
    
    @StateObject var vm: CreateProjectViewModel
    
    @StateObject var previousVm: MainViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    var assignedRequests: [RequestEntity] {
        let request: [RequestEntity] = vm.projectRequests
        let requestUnSorted = request.allSatisfy { $0.order == 0 }
        return request.sorted {
            if requestUnSorted {
                return $0.creationDate > $1.creationDate
            } else {
                return $0.order < $1.order
            }
        }
    }
    
    var unassignedRequests: [RequestEntity] {
        let request: [RequestEntity] = vm.unassignedRequests
        let requestUnSorted = request.allSatisfy { $0.order == 0 }
        return request.sorted {
            if requestUnSorted {
                return $0.creationDate > $1.creationDate
            } else {
                return $0.order < $1.order
            }
        }
    }
    
    var body: some View {
        NavigationView {
            
            let viewTitle: String = vm.title
            let projectName = $vm.name
            let projectVersion = $vm.version
            let projectIcon = vm.projectIcon
            
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Fancy Project Name", text: projectName)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("projectNameTextField")
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        
                        TextField("Version 1.0", text: projectVersion)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("versionTextField")
                    }
                    
                    HStack {
                        Button {
                            vm.shouldPresentIcons = true
                        } label: {
                            Image(systemName: projectIcon)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 10)
                                .foregroundColor(Color.cyan)
                                .background(Color.cyan.opacity(0.15))
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        
                        VStack(alignment: .leading) {
                            Text(projectName.wrappedValue)
                                .foregroundColor(.primary)
                            Text(projectVersion.wrappedValue)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .tint(Color.gray)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                Section {
                    ForEach(assignedRequests, id: \.self) { request in
                        Button {
                            vm.removeRequestFromProject(request: request)
                        } label: {
                            RequestItem(request: request) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                } header: {
                    Text("Project Request")
                }
                
                Section {
                    ForEach(unassignedRequests, id: \.self) { request in
                        Button {
                            vm.moveRequestToProject(request: request)
                        } label: {
                            RequestItem(request: request) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color.green)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .accessibilityIdentifier("unAssignedRequestBtn")
                } header: {
                    Text("Unassigned Request")
                }
                
            }
            .accessibilityIdentifier("addProjectionList")
            .navigationTitle(viewTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    PillButton {
                        vm.saveProject(presentationMode: presentationMode)
                        previousVm.reload()
                    } content: {
                        Text("Save")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                    .accessibilityIdentifier("projectSaveBtn")
                }
            }
            .popover(isPresented: $vm.shouldPresentIcons) {
                IconsView(projectIcon: $vm.projectIcon)
            }
        }
    }
}

struct CreateProjectViewAlt_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView(vm: CreateProjectViewModel(moc: PersistenceController.shared.container.viewContext), previousVm: MainViewModel(context: PersistenceController.shared.container.viewContext))
    }
}
