//
//  ProjectView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/27/21.
//

import SwiftUI
import CoreData
import Collections

class ProjectViewModel: RequestsManagement {
    
    @Published var isEditable = false
    
    @Published var project: ProjectEntity
    
    @Published var shouldOpenProjectEditView = false
    
    @Published var disableRunRequestView = false
    
    @Published var runningSequentialRequest = false
    
    private let context: NSManagedObjectContext
    
    private var removedRequests = [RequestEntity]()
    
    private var requestLoaderQueue = Deque<RequestLoader>()
    
    init(_ project: ProjectEntity, context: NSManagedObjectContext) {
        self.project = project
        self.context = context
    }
    
    var requests: [RequestEntity] {
        let request: [RequestEntity] = project.wrappedRequests
        let requestUnSorted = request.allSatisfy { $0.order == 0 }
        return request.sorted {
            if requestUnSorted {
                return $0.wrappedCreationDate > $1.wrappedCreationDate
            } else {
                return $0.order < $1.order
            }
        }
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
            let request = self.requests[index]
            self.context.delete(request)
        }
        try? context.save()
    }
    
    func reload() {}
    
    func runRequestSequentially() {
        requestLoaderQueue.removeAll()
        requestLoaderQueue.append(contentsOf: requests.map { RequestLoader(request: $0) })
        runningSequentialRequest = true
        runAll()
    }
    
    private func runAll() {
        guard let requestLoader = requestLoaderQueue.popFirst() else {
            runningSequentialRequest = false
            return
        }
        requestLoader.load { [weak self] value in
            self?.runAll()
        }
    }
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
                            Text(vm.isEditable ? "Done" : "Edit")
                        }
                        
                        Button {
                            vm.runRequestSequentially()
                        } label: {
                            Image(systemName: !vm.runningSequentialRequest ? "play.fill" : "stop.fill")
                        }
                        .foregroundColor(!vm.runningSequentialRequest ? .accentColor : .red)
                    }
                    .animation(.default, value: vm.runningSequentialRequest)
                }
            }
        }
        .environment(\.editMode, vm.isEditable ? .constant(.active) : .constant(.inactive))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.shouldOpenProjectEditView = true
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .popover(isPresented: $vm.shouldOpenProjectEditView, content: {
            CreateProjectView(vm: CreateProjectViewModel(project: self.project, moc: moc),
                              previousVm: MainViewModel(context: moc))
        })
        .navigationTitle(vm.project.wrappedName)
        .onAppear {
            vm.requests.forEach { print($0.order) }
        }
    }
}

//struct ProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectView()
//    }
//}
