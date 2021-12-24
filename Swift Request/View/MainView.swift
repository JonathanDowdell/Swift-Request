//
//  MainView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI
import CoreData

class MainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var shouldPresentCompose = false
    @Published var shouldPresentNewProject = false
    @Published var toolbarItemLeadingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var toolbarItemTrailingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var layout: Layout = .bottom
    
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
    
    @State var historyUpdateId = UUID()
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: RequestEntity.entity(), sortDescriptors: []) private var requests: FetchedResults<RequestEntity>
    
    @FetchRequest(entity: ProjectEntity.entity(), sortDescriptors: []) private var projects: FetchedResults<ProjectEntity>
    
    private var filteredProjects: [ProjectEntity] {
        projects.filter { viewModel.searchText.isEmpty ? true : $0.wrappedName.lowercased().contains(viewModel.searchText.lowercased()) }
    }
    
    private var requestHistory: [FetchedResults<RequestEntity>.Element] {
        requests.filter { $0.project == nil }
        .filter { viewModel.searchText.isEmpty ? true : $0.wrappedTitle.lowercased().contains(viewModel.searchText.lowercased()) }
    }
    
    private func deleteRequest(_ offSet: IndexSet) {
        for index in offSet {
            let request = requests[index]
            moc.delete(request)
        }
        try? moc.save()
    }
    
    fileprivate func deleteProject(_ offSet: IndexSet) {
        for index in offSet {
            let project = projects[index]
            moc.delete(project)
            try? moc.save()
        }
    }
    
    var historySection: some View {
        Section {
            ForEach(requestHistory, id: \.self) { request in
                NavigationLink {
                    RunRequestView(viewModel: RunRequestViewModel(request: request, historyUpdateId: $historyUpdateId))
                } label: {
                    RequestItem(request: request)
                }
            }
            .onDelete { offSet in
                deleteRequest(offSet)
            }
        } header: {
            Text("History")
        }
        .id(historyUpdateId)
    }
    
    var projectSection: some View {
        Section {
            ForEach(filteredProjects, id: \.self) { project in
                NavigationLink {
                    EmptyView()
                } label: {
                    ProjectItem(project: project)
                }
            }
            .onDelete { offSet in
                deleteProject(offSet)
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
                                viewModel.changeToolbarLayout()
//                                for project in projects {
//                                    moc.delete(project)
//                                }
//                                try? moc.save()
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
                        HStack {
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
                        RunRequestView(viewModel: RunRequestViewModel(historyUpdateId: $historyUpdateId))
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button { viewModel.shouldPresentCompose = false } label: {
                                        Text("Cancel")
                                    }
                                }
                            }
                    }
                }
                .popover(isPresented: $viewModel.shouldPresentNewProject) {
                    CreateProjectView(viewModel: CreateProjectViewModel(moc: moc))
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView(viewModel: MainViewModel())
                .environment(\.colorScheme, .light)
            
            MainView(viewModel: MainViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}




