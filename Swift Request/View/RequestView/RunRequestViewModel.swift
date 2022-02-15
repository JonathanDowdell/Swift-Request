//
//  RunRequestViewModel.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/14/22.
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
    @Published var json = ""
    @Published var xml = ""
    @Published var text = ""
    
    // MARK: Projects
    @Published var projects = [ProjectEntity]()
    @Published var selectedProject: ProjectEntity?
    
    // MARK: Responses
    @Published var responses = [ResponseEntity]()
    
    // MARK: Toolbar
    @Published var isSendingRequest = false
    
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
    
    // MARK: RunRequestView
    
    func runRequest() {
        _ = saveRequest()
        guard let request = self.savedRequest else { return }
        let requestLoader = RequestLoader(request: request, context: context)
        withAnimation {
            self.isSendingRequest = true
        }
        requestLoader.load { [weak self] result in
            withAnimation {
                self?.isSendingRequest = false
            }
            switch result {
            case .success(let responseDataPackage):
                self?.handleResponseDataPackage(responseDataPackage)
            case .failure(let error):
                self?.handleNetworkError(error)
            }
        }
    }
    
    private func saveRequest() -> RequestEntity? {
        var params = [ParamEntity]()
        params.append(contentsOf: urlParams)
        params.append(contentsOf: headerParams)
        
        if savedRequest == nil {
            self.savedRequest =  RequestEntity(context: context)
        }
        
        switch bodyContentType {
        case .FormURLEncoded, .MultipartFormData:
            params.append(contentsOf: bodyQueryParams)
        case .JSON:
            self.savedRequest?.raw_json = json.data(using: .utf8)
        case .XML:
            self.savedRequest?.raw_xml = xml.data(using: .utf8)
        case .Raw:
            self.savedRequest?.raw_text = text
        case .Binary: break
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
    
    // MARK: Url Section
    func addURLQueryParam() {
        let queryParam = ParamEntity(context: context)
        queryParam.raw_type = ParamType.URL.rawValue
        queryParam.active = true
        withAnimation {
            urlParams.append(queryParam)
        }
    }
    
    func removeURLQueryParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        urlParams.remove(at: element)
    }
    
    // MARK: Header Section
    func addHeaderParam() {
        let queryParam = ParamEntity(context: context)
        queryParam.raw_type = ParamType.Header.rawValue
        queryParam.active = true
        withAnimation {
            headerParams.append(queryParam)
        }
    }
    
    func removeHeaderParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        headerParams.remove(at: element)
    }
    
    // MARK: Body Section
    func addBodyParam() {
        let queryParam = ParamEntity(context: context)
        queryParam.raw_type = ParamType.Body.rawValue
        queryParam.active = true
        withAnimation {
            switch bodyContentType {
            case .FormURLEncoded, .MultipartFormData:
                bodyQueryParams.append(queryParam)
            case .Binary:
                print("Binary")
            case .JSON:
                print("JSON")
            case .XML:
                print("XML")
            case .Raw:
                print("Raw")
            }
        }
    }
    
    func removeBodyParam(_ offSet: IndexSet) {
        for index in offSet {
            let element = bodyQueryParams[index]
            context.delete(element)
        }
        bodyQueryParams.remove(atOffsets: offSet)
        try? context.save()
    }
    
}
