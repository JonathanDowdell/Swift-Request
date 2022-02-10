//
//  CreateProjectViewAlt.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/23/21.
//

import SwiftUI
import CoreData

class CreateProjectViewModel: ObservableObject {
    @Published var name = ""
    @Published var version = ""
    @Published var shouldPresentIcons = false
    @Published var projectIcon = "network"
    
    @Published var projectRequests = [RequestEntity]()
    
    @Published var unassignedRequests = [RequestEntity]()
    
    @Published var project: ProjectEntity?
    
    private let moc: NSManagedObjectContext
    
    let title: String
    
    
    init(project: ProjectEntity? = nil, moc: NSManagedObjectContext) {
        if let project = project {
            self.name = project.wrappedName
            self.version = project.wrappedVersion
            self.project = project
            self.title = "Edit Project"
            self.projectRequests = project.wrappedRequests
        } else {
            self.title = "Create Project"
        }
        
        self.moc = moc
        
        do {
            let requests: [RequestEntity] = try moc.fetch(RequestEntity.fetchRequest())
            unassignedRequests = requests.filter { $0.project == nil }
        } catch {
            print(error)
        }
    }
    
    fileprivate func removeRequestFromProject(request: RequestEntity) {
        guard let requestIndex = projectRequests.firstIndex(of: request) else { return }
        projectRequests.remove(at: requestIndex)
        unassignedRequests.append(request)
    }
    
    fileprivate func moveRequestToProject(request: RequestEntity) {
        guard let requestIndex = unassignedRequests.firstIndex(of: request) else { return }
        unassignedRequests.remove(at: requestIndex)
        projectRequests.append(request)
    }
    
    fileprivate func saveProject(presentationMode: Binding<PresentationMode>) {
        let project = self.project ?? ProjectEntity(context: moc)
        project.name = self.name
        project.creationDate = Date()
        project.systemIcon = self.projectIcon
        project.version = self.version.isEmpty ? "Version 1.0" : self.version
        project.wrappedRequests.forEach {
            $0.order = 0
            project.removeFromRequests($0)
        }
        for projectRequest in projectRequests {
            project.addToRequests(projectRequest)
            projectRequest.project = project
        }
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
}

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
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Fancy Project Name", text: $vm.name)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("projectNameTextField")
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        TextField("Version 1.0", text: $vm.version)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("versionTextField")
                    }
                    
                    HStack {
                        Button {
                            vm.shouldPresentIcons = true
                        } label: {
                            Image(systemName: vm.projectIcon)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 10)
                                .foregroundColor(Color.cyan)
                                .background(Color.cyan.opacity(0.15))
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        
                        VStack(alignment: .leading) {
                            Text(vm.name)
                                .foregroundColor(.primary)
                            Text(vm.version)
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
            
            .navigationTitle(vm.title)
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
