//
//  ProjectViewModel.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/14/22.
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
    
    @Published var updateToken = UUID()
    
    private let context: NSManagedObjectContext
    
    private var removedRequests = [RequestEntity]()
    
    private var requestLoaderQueue = Deque<RequestLoader>()
    
    init(_ project: ProjectEntity, context: NSManagedObjectContext) {
        self.project = project
        self.context = context
    }
    
    var requests: [RequestEntity] {
        let requests: [RequestEntity] = project.requests
        let requestUnSorted = requests.allSatisfy { $0.order == 0 }
        return requests.sorted {
            if requestUnSorted {
                return $0.creationDate > $1.creationDate
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
    
    func reload() {
        
    }
    
    func runRequestSequentially() {
        requestLoaderQueue.removeAll()
        requestLoaderQueue.append(contentsOf: requests.map { RequestLoader(request: $0, context: context) })
        runningSequentialRequest = true
        runAll()
    }
    
    private func runAll() {
        guard let requestLoader = requestLoaderQueue.popFirst() else {
            runningSequentialRequest = false
            return
        }
        requestLoader.load { [weak self] results in
            if let package = try? results.get() {
                self?.handleResponseDataPackage(package, with: requestLoader.request)
            }
            self?.runAll()
        }
    }
    
    func handleResponseDataPackage(_ responseDataPackage: ResponseDataPackage, with request: RequestEntity) {
        let responseEntity = ResponseEntity(context: context)
        if let response = responseDataPackage.response as? HTTPURLResponse {
            responseEntity.statusCode = Int64(response.statusCode)
            responseEntity.url = response.url?.absoluteString ?? ""
            response.allHeaderFields.forEach { header in
                let headerEntity = HeaderEntity(context: context)
                headerEntity.type = ParamType.Response
                headerEntity.key = header.key.description
                headerEntity.value = "\(header.value)"
                responseEntity.addHeader(headerEntity)
            }
        }
        responseEntity.responseTime = Int64(responseDataPackage.responseTime)
        responseEntity.creationDate = Date()
        responseEntity.body = responseDataPackage.data
        request.addResponses(responseEntity)
        try? context.save()
    }
}
