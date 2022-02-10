//
//  RunRequestView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI
import CoreData

protocol ResponseProtocol: ObservableObject {
    var responses: [ResponseEntity] { get set }
    func removeResponse(_ response: ResponseEntity)
}

class RunRequestViewModel: ObservableObject, ResponseProtocol {
    
    // MARK: URL
    @Published var title = ""
    @Published var url = ""
    @Published var urlParams = [ParamEntity]()
    @Published var methodType: MethodType = .GET
    
    // MARK: Header
    @Published var headerParams = [ParamEntity]()
    
    // MARK: Body
    @Published var bodyContentType: BodyType = .FormURLEncoded
    @Published var bodyQueryParams = [ParamEntity]()
    
    
    // MARK: Projects
    @Published var projects = [ProjectEntity]()
    @Published var selectedProject: ProjectEntity?
    
    // MARK: Responses
    @Published var responses = [ResponseEntity]()
    
    var shouldUpdate = false
    var savedRequest: RequestEntity?
    
    let context: NSManagedObjectContext
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init(request: RequestEntity, context: NSManagedObjectContext) {
        self.init(context: context)
        self.savedRequest = request
        self.title = request.title
        self.url = request.url
        self.methodType = request.methodType
        self.bodyContentType = request.contentType
        let urlParams = request.params.filter { return $0.type == .URL }
        let headerParams = request.params.filter { return $0.type == .Header }
        let bodyQueryParams = request.params.filter { return $0.type == .Body }
        
        self.urlParams = urlParams
        self.headerParams = headerParams
        self.bodyQueryParams = bodyQueryParams
        self.selectedProject = request.project
        self.responses = request.responses
        
    }
    
    private func saveRequest() -> RequestEntity? {
        var params = [ParamEntity]()
        params.append(contentsOf: urlParams)
        params.append(contentsOf: headerParams)
        
        switch bodyContentType {
        case .FormURLEncoded, .MultipartFormData:
            params.append(contentsOf: bodyQueryParams)
        case .JSON: break
        case .XML: break
        case .Raw: break
        case .Binary: break
        }
        
        if savedRequest == nil {
            self.savedRequest =  RequestEntity(context: context)
        }
        
        savedRequest?.method = methodType.rawValue
        savedRequest?.url = url
        savedRequest?.title = title
        savedRequest?.creationDate = savedRequest?.creationDate ?? Date()
        savedRequest?.contentType = bodyContentType 
        for param in params {
            savedRequest?.addToRaw_params(param)
        }
        
        try? context.save()
        
        shouldUpdate = true
        
        return savedRequest
    }
    
    func runRequest() {
        _ = saveRequest()
        guard let request = self.savedRequest else { return }
        let requestLoader = RequestLoader(request: request, context: context)
        requestLoader.load { [weak self] result in
            switch result {
            case .success(let responseDataPackage):
                self?.handleResponseDataPackage(responseDataPackage)
            case .failure(let error):
                self?.handleNetworkError(error)
            }
        }
    }
    
    func saveProject() {
        savedRequest?.project = selectedProject
        try? context.save()
    }
    
    private func handleResponseDataPackage(_ responseDataPackage: ResponseDataPackage) {
        let responseEntity = ResponseEntity(context: context)
        if let response = responseDataPackage.response as? HTTPURLResponse {
            responseEntity.statusCode = Int64(response.statusCode)
            responseEntity.raw_url = response.url?.absoluteString
            response.allHeaderFields.forEach { header in
                let headerEntity = HeaderEntity(context: context)
                headerEntity.type = ParamType.Response
                headerEntity.key = header.key.description
                headerEntity.raw_value = "\(header.value)"
                responseEntity.addHeader(headerEntity)
            }
        }
        responseEntity.responseTime = Int64(responseDataPackage.responseTime)
        responseEntity.creationDate = Date()
        responseEntity.body = responseDataPackage.data
        savedRequest?.addResponses(responseEntity)
        try? context.save()
        withAnimation {
            self.responses.append(responseEntity)
        }
    }
    
    func removeResponse(_ response: ResponseEntity) {
        guard let index = responses.firstIndex(of: response) else { return }
        responses.remove(at: index)
        context.delete(response)
        try? context.save()
    }
    
    func handleNetworkError(_ error: NetworkError) {
        
    }
    
}

struct RunRequestView<RequestManager>: View where RequestManager: RequestsManagement {
    
    @StateObject var vm: RunRequestViewModel
    
    @StateObject var requestsManager: RequestManager
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {
        List {
            
            urlSection
            
            headerSection
            
            bodySection
            
            responseSection
            
            projectSection

        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: runRequest) {
                    Image(systemName: "play.fill")
                }
                .accessibilityIdentifier("runRequestBtn")
            }
        }
        .navigationTitle("Run Request")
        .onDisappear {
            withAnimation {
                if vm.shouldUpdate {
                    vm.saveProject()
                    requestsManager.reload()
                }
            }
        }
    }
    
    private func runRequest() {
        vm.runRequest()
        requestsManager.reload()
    }
}

struct RunRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context = PersistenceController.shared.container.viewContext
            
            NavigationView {
                RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                    .environment(\.colorScheme, .light)
            }
            
            NavigationView {
                RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                    .environment(\.colorScheme, .dark)
            }
        }
    }
}


