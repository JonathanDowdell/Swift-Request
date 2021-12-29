//
//  MainViewModel.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/26/21.
//

import SwiftUI
import CoreData

protocol RequestsManagement: ObservableObject {
    func reload()
}

class MainViewModel: RequestsManagement {
    @Published var searchText = ""
    @Published var shouldPresentCompose = false
    @Published var shouldPresentNewProject = false
    @Published var toolbarItemLeadingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var toolbarItemTrailingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var layout: Layout = .bottom
    
    @Published var projects = [ProjectEntity]()
    
    @Published var requests = [RequestEntity]()
    
    var filteredProjects: [FetchedResults<ProjectEntity>.Element] {
        projects.filter { searchText.isEmpty ? true : $0.wrappedName.lowercased().contains(searchText.lowercased()) }
    }
    
    var requestHistory: [FetchedResults<RequestEntity>.Element] {
        requests.filter { $0.project == nil }
        .filter { searchText.isEmpty ? true : $0.wrappedTitle.lowercased().contains(searchText.lowercased()) }
    }
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        reload()
    }
    
    func reload() {
        guard let projects = try? context.fetch(ProjectEntity.fetchRequest()) else { return }
        self.projects = projects
        
        guard let request = try? context.fetch(RequestEntity.fetchRequest()) else { return }
        self.requests = request
    }
    
    func deleteRequest(_ offSet: IndexSet) {
        for index in offSet {
            let request = requests[index]
            context.delete(request)
        }
        try? context.save()
        reload()
    }
    
    func deleteProject(_ offSet: IndexSet) {
        for index in offSet {
            let project = projects[index]
            context.delete(project)
        }
        try? context.save()
        reload()
    }
    
    enum Layout: String {
    case top, bottom
    }
    
    func changeToolbarLayout() {
        if layout == .bottom {
            toolbarItemLeadingPlacement = .navigationBarLeading
            toolbarItemTrailingPlacement = .navigationBarTrailing
            layout = .top
        } else {
            toolbarItemLeadingPlacement = .bottomBar
            toolbarItemTrailingPlacement = .bottomBar
            layout = .bottom
        }
    }
}

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel
    
    @Environment(\.managedObjectContext) var moc
    
    var historySection: some View {
        Section {
            ForEach(viewModel.requestHistory, id: \.self) { request in
                NavigationLink {
                    RunRequestView(vm: RunRequestViewModel(request: request, context: moc),
                                   requestsManager: viewModel)
                } label: {
                    RequestItem(request: request)
                }
            }
            .onDelete { offSet in
                viewModel.deleteRequest(offSet)
            }
        } header: {
            Text("History")
        }
    }
    
    var projectSection: some View {
        Section {
            ForEach(viewModel.filteredProjects, id: \.self) { project in
                NavigationLink {
                    ProjectView(vm: ProjectViewModel(project, context: moc),
                                project: project)
                } label: {
                    ProjectItem(project: project)
                }
            }
            .onDelete { offSet in
                viewModel.deleteProject(offSet)
            }
        } header: {
            Text("Projects")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    projectSection
                    
                    historySection
                }
                .navigationTitle("Requests")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                .toolbar {
                    ToolbarItem(placement: viewModel.toolbarItemLeadingPlacement) {
                        HStack {
                            Button {
                                
                                withAnimation {
                                    viewModel.reload()
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                            
                            if viewModel.layout == .bottom {
                                Button {
                                    viewModel.shouldPresentNewProject = true
                                } label: {
                                    Image(systemName: "folder.badge.plus")
                                }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: viewModel.toolbarItemTrailingPlacement) {
                        HStack(spacing: 20) {
                            if viewModel.layout == .top {
                                Button {
                                    viewModel.shouldPresentNewProject = true
                                } label: {
                                    Image(systemName: "folder.badge.plus")
                                }
                            }
                            
                            Button {
                                viewModel.shouldPresentCompose = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                }
                .popover(isPresented: $viewModel.shouldPresentCompose) {
                    NavigationView {
                        RunRequestView(vm: RunRequestViewModel(context: moc), requestsManager: viewModel)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button { viewModel.shouldPresentCompose = false } label: {
                                        Text("Close")
                                    }
                                }
                            }
                    }
                }
                .popover(isPresented: $viewModel.shouldPresentNewProject) {
                    CreateProjectView(vm: CreateProjectViewModel(moc: moc), previousVm: viewModel)
                }
            }
            .onAppear {
                viewModel.reload()
            }
        }
    }
}

struct MainViewAlt_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(context: PersistenceController.shared.container.viewContext))
    }
}
