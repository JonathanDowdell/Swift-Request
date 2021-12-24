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
    var methodOptions = MethodType.allCases
    
    // MARK: Header
    @Published var headerParams = [ParamEntity]()
    
    // MARK: Body
    @Published var bodyContentType: BodyType = .FormURLEncoded
    @Published var bodyFormURLEncodedQueryParams = [ParamEntity]()
    var bodyTypeOptions = BodyType.allCases
    
    // MARK: Projects
    @Published var projects = [ProjectEntity]()
    @Published var selectedProject: ProjectEntity?
    
    @Published var sectionSelectionIndex = "Request"
    
    @Published var sectionSelection = ["Request", "Response"]
    
    var shouldUpdate = false
    
    var historyUpdateId: Binding<UUID>
    
    var savedRequest: RequestEntity?
    
    init(historyUpdateId: Binding<UUID>) {
        self.historyUpdateId = historyUpdateId
    }
    
    convenience init(request: RequestEntity, historyUpdateId: Binding<UUID>) {
        self.init(historyUpdateId: historyUpdateId)
        self.savedRequest = request
        self.title = request.wrappedTitle
        self.url = request.wrappedURL
    }
    
    func saveRequestEntity(context: NSManagedObjectContext) -> RequestEntity {
        var params = [ParamEntity]()
        params.append(contentsOf: urlParams)
        params.append(contentsOf: headerParams)
        if bodyContentType == .FormURLEncoded {
            params.append(contentsOf: bodyFormURLEncodedQueryParams)
        }
        
        if savedRequest == nil {
            self.savedRequest =  RequestEntity(context: context)
        }
        
        savedRequest?.method = methodType.rawValue
        savedRequest?.url = url
        savedRequest?.title = title
        savedRequest?.creationDate = Date()
        for param in params {
            savedRequest?.addToParams(param)
        }
        
        if let selectedProject = selectedProject {
            savedRequest?.project = selectedProject
        }
        
        try? context.save()
        
        shouldUpdate = true
        
        return savedRequest!
    }
}

struct RunRequestView: View {
    
    @StateObject var viewModel: RunRequestViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                urlSection
                
                headerSection
                
                bodyContentSection
                
                let name = viewModel.selectedProject?.wrappedName ?? ""
                
                NavigationLink {
                    CreateRequestProjectView(selectedProject: $viewModel.selectedProject)
                } label: {
                    HStack {
                        Image(systemName: "folder")
                            .padding(.trailing, 14)
                            .foregroundColor(viewModel.selectedProject == nil ? .gray : .accentColor)
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
                
                ToolbarItem(placement: .bottomBar) {
                    Text("")
                }
//                ToolbarItem(placement: .bottomBar) {
//                    Picker(selection: $viewModel.sectionSelectionIndex) {
//                        ForEach(viewModel.sectionSelection, id: \.self) {
//                            Text($0)
//                        }
//                    } label: {
//
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
            }
            .navigationTitle("Run Request")
            
        }
        .onDisappear {
            withAnimation {
                if viewModel.shouldUpdate {
                    viewModel.historyUpdateId.wrappedValue = UUID()
                }
            }
        }
    }
    
    private func runRequest() {
        let savedRequest = viewModel.saveRequestEntity(context: moc)
    }
}

struct CreateRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RunRequestView(viewModel: RunRequestViewModel(historyUpdateId: .constant(UUID())))
                .environment(\.colorScheme, .light)
            
            RunRequestView(viewModel: RunRequestViewModel(historyUpdateId: .constant(UUID())))
                .environment(\.colorScheme, .dark)
        }
    }
}


