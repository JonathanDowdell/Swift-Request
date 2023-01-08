//
//  CreateProjectViewAlt.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/23/21.
//

import SwiftUI

struct CreateProjectView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    
    @State private var title = ""
    
    @State private var version = ""
    
    @State private var shouldPresentIcons = false
    
    @State private var projectIcon = "network"
    
    @State private var projectRequests = [RequestEntity]()
    
    @State private var unassignedRequests = [RequestEntity]()
    
    private var project: ProjectEntity?
    
    private var previousVm: MainViewModel?
    
    private var sortedAssignedRequests: [RequestEntity] {
        let request: [RequestEntity] = projectRequests
        let requestUnSorted = request.allSatisfy { $0.order == 0 }
        return request.sorted {
            if requestUnSorted {
                return $0.creationDate > $1.creationDate
            } else {
                return $0.order < $1.order
            }
        }
    }
    
    private var sortedUnassignedRequests: [RequestEntity] {
        let request: [RequestEntity] = unassignedRequests
        let requestUnSorted = request.allSatisfy { $0.order == 0 }
        return request.sorted {
            if requestUnSorted {
                return $0.creationDate > $1.creationDate
            } else {
                return $0.order < $1.order
            }
        }
    }
    
    init(project: ProjectEntity?, previousVm: MainViewModel? = nil) {
        self.project = project
        self.previousVm = previousVm
    }
    
    private var createNewProjectSection: some View {
        Section {
            HStack {
                Text("Name")
                Spacer()
                TextField("Fancy Project Name", text: $name)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier("projectNameTextField")
            }
            
            HStack {
                Text("Version")
                Spacer()
                
                TextField("Version 1.0", text: $version)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier("versionTextField")
            }
            
            HStack {
                Button {
                    shouldPresentIcons = true
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
                    Text(name)
                        .foregroundColor(.primary)
                    Text(version)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .tint(Color.gray)
                }
                .padding(.vertical, 10)
            }
        }
    }
    
    private var assignedProjectSection: some View {
        Section {
            ForEach(sortedAssignedRequests, id: \.self) { request in
                Button {
                    removeRequestFromProject(request: request)
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
    }
    
    private var unassignedProjectSection: some View {
        Section {
            ForEach(sortedUnassignedRequests, id: \.self) { request in
                Button {
                    moveRequestToProject(request: request)
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
    
    var body: some View {
        NavigationView {
            
            List {
                createNewProjectSection
                
                assignedProjectSection
                
                unassignedProjectSection
            }
            .accessibilityIdentifier("addProjectionList")
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    PillButton {
                        saveProject(presentationMode: presentationMode)
                        previousVm?.reload()
                    } content: {
                        Text("Save")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                    .accessibilityIdentifier("projectSaveBtn")
                }
            }
            .onAppear {
                loadProject()
                loadUnassignedRequest()
            }
            .popover(isPresented: $shouldPresentIcons) {
                IconsView(projectIcon: $projectIcon)
            }
        }
    }
    
    private func loadProject() {
        if let project = project {
            self.title = "Edit Project"
            self.name = project.name
            self.version = project.version
            self.projectRequests = project.requests
        } else {
            self.title = "Create Project"
        }
    }
    
    private func loadUnassignedRequest() {
        do {
            let requests: [RequestEntity] = try moc.fetch(RequestEntity.fetchRequest())
            self.unassignedRequests = requests.filter { $0.project == nil }
        } catch {
            print(error)
        }
    }
    
    private func removeRequestFromProject(request: RequestEntity) {
        guard let requestIndex = projectRequests.firstIndex(of: request) else { return }
        projectRequests.remove(at: requestIndex)
        unassignedRequests.append(request)
    }
    
    private func moveRequestToProject(request: RequestEntity) {
        guard let requestIndex = unassignedRequests.firstIndex(of: request) else { return }
        unassignedRequests.remove(at: requestIndex)
        projectRequests.append(request)
    }
    
    private func saveProject(presentationMode: Binding<PresentationMode>) {
        let project = self.project ?? ProjectEntity(context: moc)
        project.raw_name = self.name
        project.raw_creation_date = project.raw_creation_date ?? Date()
        project.raw_system_icon = self.projectIcon
        project.raw_version = self.version.isEmpty ? "Version 1.0" : self.version
        project.requests.forEach {
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

//struct CreateProjectViewAlt_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateProjectView(vm: CreateProjectViewModel(moc: PersistenceController.shared.container.viewContext), previousVm: MainViewModel(context: PersistenceController.shared.container.viewContext))
//    }
//}
