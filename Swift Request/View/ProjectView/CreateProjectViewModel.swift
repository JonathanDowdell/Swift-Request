//
//  CreateProjectViewModel.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/14/22.
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
    
    private let context: NSManagedObjectContext
    let title: String
    
    
    init(project: ProjectEntity? = nil, moc: NSManagedObjectContext) {
        if let project = project {
            self.name = project.name
            self.version = project.version
            self.project = project
            self.title = "Edit Project"
            self.projectRequests = project.requests
        } else {
            self.title = "Create Project"
        }
        
        self.context = moc
        
        do {
            let requests: [RequestEntity] = try moc.fetch(RequestEntity.fetchRequest())
            unassignedRequests = requests.filter { $0.project == nil }
        } catch {
            print(error)
        }
    }
    
    func removeRequestFromProject(request: RequestEntity) {
        guard let requestIndex = projectRequests.firstIndex(of: request) else { return }
        projectRequests.remove(at: requestIndex)
        unassignedRequests.append(request)
    }
    
    func moveRequestToProject(request: RequestEntity) {
        guard let requestIndex = unassignedRequests.firstIndex(of: request) else { return }
        unassignedRequests.remove(at: requestIndex)
        projectRequests.append(request)
    }
    
    func saveProject(presentationMode: Binding<PresentationMode>) {
        let project = self.project ?? ProjectEntity(context: context)
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
        try? context.save()
        presentationMode.wrappedValue.dismiss()
    }
    
}
