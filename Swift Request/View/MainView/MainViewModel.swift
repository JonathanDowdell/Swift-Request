//
//  MainViewModel.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/14/22.
//

import SwiftUI
import CoreData

protocol RequestsManagement: ObservableObject {
    func reload()
}

class MainViewModel: RequestsManagement {
    @Published var searchText = ""
    @Published var shouldPopOverSettings = false
    @Published var shouldPresentCompose = false
    @Published var shouldPresentNewProject = false
    @Published var toolbarItemLeadingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var toolbarItemTrailingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var layout: Layout = .bottom
    
    @Published var projects = [ProjectEntity]()
    
    @Published var requests = [RequestEntity]()
    
    var filteredProjects: [FetchedResults<ProjectEntity>.Element] {
        return projects.filter { searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var requestHistory: [FetchedResults<RequestEntity>.Element] {
        return requests.filter { $0.project == nil }
        .filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        .sorted { $0.creationDate > $1.creationDate }
    }
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
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
            let request = requests.sorted { $0.creationDate > $1.creationDate }[index]
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
    
    func deleteProject(_ project: ProjectEntity) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                self.context.delete(project)
                try? self.context.save()
                self.reload()
            }
        }
    }
    
    func duplicateProject(_ project: ProjectEntity) {
        
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
