//
//  ProjectView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/27/21.
//

import SwiftUI
import CoreData

class ProjectViewModel: RequestsManagement {
    
    @Published var isEditable = false
    
    @Published var project: ProjectEntity
    
    @Published var shouldOpenEditView = false
    
    private let context: NSManagedObjectContext
    
    init(_ project: ProjectEntity, context: NSManagedObjectContext) {
        self.project = project
        self.context = context
    }
    
    var requests: [RequestEntity] {
        return project.wrappedRequests.sorted { $0.order < $1.order }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        var revisedItems: [RequestEntity] = requests.map { $0 }
        
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for reversedIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[reversedIndex].order = Int64(reversedIndex)
        }
        
        try? context.save()
    }
    
    func delete(_ offSet: IndexSet) {
        for index in offSet {
            let request = requests[index]
            context.delete(request)
        }
        try? context.save()
    }
    
    func reload() {}
    
}

struct ProjectView: View {
    
    @StateObject var vm: ProjectViewModel
    
    @ObservedObject var project: ProjectEntity
    
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
        List {
            if vm.requests.hasContent {
                Section {
                    ForEach(vm.requests, id: \.self) { request in
                        NavigationLink {
                            RunRequestView(vm: RunRequestViewModel(request: request, context: moc),
                                           requestsManager: ProjectViewModel(vm.project, context: moc))
                        } label: {
                            RequestItem(request: request) {
                                
                            }
                            .padding(.vertical, 8)
                        }

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
                            Text(vm.isEditable ? "Done" : "Edit")
                        }
                        
                        Button {
                            vm.project.name = "Playground"
                            try? moc.save()
                        } label: {
                            Image(systemName: "flowchart.fill")
                        }
                    }
                }
            }
        }
        .environment(\.editMode, vm.isEditable ? .constant(.active) : .constant(.inactive))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.shouldOpenEditView = true
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .popover(isPresented: $vm.shouldOpenEditView, content: {
            CreateProjectView(vm: CreateProjectViewModel(project: self.project, moc: moc), previousVm: MainViewModel(context: moc))
        })
        .navigationTitle(vm.project.wrappedName)
    }
}

//struct ProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectView()
//    }
//}

