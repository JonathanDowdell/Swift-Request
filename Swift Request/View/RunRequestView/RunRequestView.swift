//
//  RunRequestView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI
import CoreData

class RunRequestViewModel: ObservableObject {
    
    // MARK: URL
    @Published var title = ""
    @Published var url = ""
    @Published var urlParams = [ParamEntity]()
    @Published var methodType: MethodType = .GET
    
    // MARK: Header
    @Published var headerParams = [ParamEntity]()
    
    // MARK: Body
    @Published var bodyContentType: BodyType = .FormURLEncoded
    @Published var bodyFormURLEncodedQueryParams = [ParamEntity]()
    
    // MARK: Projects
    @Published var projects = [ProjectEntity]()
    @Published var selectedProject: ProjectEntity?
    
    var shouldUpdate = false
    var savedRequest: RequestEntity?
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init(request: RequestEntity, context: NSManagedObjectContext) {
        self.init(context: context)
        self.savedRequest = request
        self.title = request.wrappedTitle
        self.url = request.wrappedURL
        self.methodType = request.wrappedMethodType
        self.bodyContentType = request.wrappedContentType
        let urlParams = request.wrappedParams.filter { return $0.wrappedType == .URL }
        let headerParams = request.wrappedParams.filter { return $0.wrappedType == .Header }
        let bodyFormURLEncodedQueryParams = request.wrappedParams.filter { return $0.wrappedType == .Body }
        
        
        self.urlParams = urlParams
        self.headerParams = headerParams
        self.bodyFormURLEncodedQueryParams = bodyFormURLEncodedQueryParams
        self.selectedProject = request.project
    }
    
    func saveRequest() -> RequestEntity? {
        var params = [ParamEntity]()
        params.append(contentsOf: urlParams)
        params.append(contentsOf: headerParams)
        
        switch bodyContentType {
        case .FormURLEncoded:
            params.append(contentsOf: bodyFormURLEncodedQueryParams)
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
        savedRequest?.creationDate = Date()
        savedRequest?.contentType = bodyContentType.rawValue
        savedRequest?.order = 0
        
        for param in params {
            savedRequest?.addToParams(param)
        }
        
        try? context.save()
        
        shouldUpdate = true
        
        return savedRequest!
    }
    
    func saveProject() {
        savedRequest?.project = selectedProject
        try? context.save()
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
            
            bodyContentSection
            
            let name = vm.selectedProject?.wrappedName ?? ""
            
            NavigationLink {
                CreateRequestProjectView(selectedProject: $vm.selectedProject)
                    .onAppear {
                        vm.shouldUpdate = false
                    }
                    .onDisappear {
                        vm.shouldUpdate = true
                    }
            } label: {
                HStack {
                    Image(systemName: "folder")
                        .padding(.trailing, 14)
                        .foregroundColor(vm.selectedProject == nil ? .gray : .accentColor)
                    Text("Project")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(name)
                        .foregroundColor(.accentColor)
                }
                .tint(Color.accentColor)
            }
            
            
            
            Section("Response") {
            }
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: runRequest) {
                    Image(systemName: "play.fill")
                }
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
        let _ = vm.saveRequest()
        requestsManager.reload()
    }
}

struct RunRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context = PersistenceController.shared.container.viewContext
            
            RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                .environment(\.colorScheme, .light)
            
            RunRequestView(vm: RunRequestViewModel(context: context), requestsManager: MainViewModel(context: context))
                .environment(\.colorScheme, .dark)
        }
    }
}


