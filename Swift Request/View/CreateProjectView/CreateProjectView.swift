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
    
    private var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
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
        let project = ProjectEntity(context: moc)
        project.name = self.name
        project.creationDate = Date()
        project.systemIcon = self.projectIcon
        project.version = self.version.isEmpty ? "Version 1.0" : self.version
        for projectRequest in projectRequests {
            project.addToRequests(projectRequest)
            projectRequest.project = project
        }
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct CreateProjectView: View {
    @StateObject var viewModel: CreateProjectViewModel
    
    @State var project: ProjectEntity?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Fancy Project Name", text: $viewModel.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        TextField("Version 1.0", text: $viewModel.version)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Button {
                            viewModel.shouldPresentIcons = true
                        } label: {
                            Image(systemName: viewModel.projectIcon)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 10)
                                .foregroundColor(Color.cyan)
                                .background(Color.cyan.opacity(0.15))
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        
                        VStack(alignment: .leading) {
                            Text(viewModel.name)
                                .foregroundColor(.primary)
                            Text(viewModel.version)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .tint(Color.gray)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                Section {
                    ForEach(viewModel.projectRequests, id: \.self) { request in
                        Button {
                            viewModel.removeRequestFromProject(request: request)
                        } label: {
                            RequestItem(request: request) {
                                Spacer()
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
                    ForEach(viewModel.unassignedRequests, id: \.self) { request in
                        Button {
                            viewModel.moveRequestToProject(request: request)
                        } label: {
                            RequestItem(request: request) {
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color.green)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                } header: {
                    Text("Unassigned Request")
                }
                
                
            }
            .navigationTitle("Create Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    PillButton {
                        viewModel.saveProject(presentationMode: presentationMode)
                    } content: {
                        Text("Save")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .popover(isPresented: $viewModel.shouldPresentIcons) {
                IconsView(projectIcon: $viewModel.projectIcon)
            }
        }
    }
}

struct CreateProjectViewAlt_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView(viewModel: CreateProjectViewModel(moc: PersistenceController.shared.container.viewContext))
    }
}
