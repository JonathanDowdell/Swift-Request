//
//  CreateRequestView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

class CreateRequestViewModel: ObservableObject {
    @Published var urlQueryParams = [QueryParamEntity]()
    @Published var title = ""
    @Published var url = ""
    
    @Published var methodSelectionIndex = 0
    var methodOptions = Method.allCases
    
    @Published var bodyTypeSelectionIndex = 0
    var bodyTypeOptions = BodyType.allCases
    
    @Published var chosenBodyType: BodyType = .URLEncoded
    @Published var bodyEncodedQueryParams = [QueryParamEntity]()
    @Published var bodyFormDataQueryParams = [QueryParamEntity]()
    
    @Published var headersParams = [QueryParamEntity]()
}

enum Method: String, CaseIterable {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTION
    
    func color() -> (primary: Color, secondary: Color) {
        switch self {
        case .GET:
            return (Color.cyan, Color.cyan.opacity(0.15))
        case .POST:
            return (Color.green, Color.green.opacity(0.15))
        case .PUT:
            return (Color.purple, Color.purple.opacity(0.15))
        case .PATCH:
            return (Color.orange, Color.orange.opacity(0.15))
        case .DELETE:
            return (Color.red, Color.red.opacity(0.15))
        case .HEAD:
            return (Color.indigo, Color.indigo.opacity(0.15))
        case .OPTION:
            return (Color.gray, Color.gray.opacity(0.15))
        }
    }
}

enum BodyType: String, CaseIterable {
    case URLEncoded, FormData, Raw, Binary
    
    func color() -> (primary: Color, secondary: Color) {
        switch self {
        case .URLEncoded:
            return (Color.green, Color.green.opacity(0.15))
        case .FormData:
            return (Color.orange, Color.orange.opacity(0.15))
        case .Raw:
            return (Color.cyan, Color.cyan.opacity(0.15))
        case .Binary:
            return (Color.indigo, Color.indigo.opacity(0.15))
        }
    }
}

struct CreateRequestView: View {
    
    @StateObject var viewModel: CreateRequestViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    
    // MARK: URL Section
    
    private var urlSection: some View {
        Section {
            HStack {
                Image(systemName: "personalhotspot")
                    .padding(.trailing, 10)
                    .foregroundColor(viewModel.url.isEmpty ? Color.gray : Color.accentColor)
                Text("URL")
                    .foregroundColor(Color.gray)
                Spacer()
                TextField("Localhost:3000", text: $viewModel.url)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, 10)
            }
            Picker(selection: $viewModel.methodSelectionIndex) {
                ForEach(0..<viewModel.methodOptions.count, id: \.self) {
                    let method = viewModel.methodOptions[$0]
                    Text(method.rawValue)
                        .font(.caption2)
                        .bold()
                        .padding(5)
                        .foregroundColor(method.color().primary)
                        .background(method.color().secondary)
                        .cornerRadius(10)
                }
            } label: {
                HStack {
                    Image(systemName: "bolt.horizontal")
                        .padding(.trailing, 10)
                        .foregroundColor(Color.accentColor)
                    Text("Method")
                        .foregroundColor(.gray)
                }
            }
            
            ForEach(viewModel.urlQueryParams, id: \.self) {
                QueryParamItem(queryParam: $0)
            }
            .onDelete(perform: removeQueryParam)
            
            Button(action: addQueryParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    
                    Spacer()
                    
                    Text("Add URL Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }

        } header: {
            Text("URL")
        }
    }
    
    // MARK: Header
    
    private var headerSection: some View {
        Section {
            ForEach(viewModel.headersParams, id: \.self) {
                QueryParamItem(queryParam: $0)
            }
            .onDelete(perform: removeHeaderParam)
            
            Button(action: addHeaderParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    
                    Spacer()
                    
                    Text("Add Header Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
            
        } header: {
            HStack {
                Text("Headers")
            }
        }
    }
    
    // MARK: Query Section
    
    private func addQueryParam() {
        let queryParam = QueryParamEntity(context: moc)
        queryParam.active = false
        withAnimation {
            viewModel.urlQueryParams.append(queryParam)
        }
    }
    
    private func removeQueryParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        viewModel.urlQueryParams.remove(at: element)
    }
    
    // MARK: Body Content
    
    private var bodyContentSection: some View {
        Section {
            Picker(selection: $viewModel.chosenBodyType) {
                ForEach(BodyType.allCases, id: \.self) {
                    let method = $0
                    Text(method.rawValue)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .foregroundColor(method.color().primary)
                        .background(method.color().secondary)
                        .cornerRadius(10)
                }
            } label: {
                let active = (!viewModel.bodyEncodedQueryParams.isEmpty || !viewModel.bodyFormDataQueryParams.isEmpty)
                
                HStack {
                    Image(systemName: "shippingbox")
                        .padding(.trailing, 14)
                        .foregroundColor(active ? Color.accentColor : Color.gray)
                    Text("Content")
                        .foregroundColor(.gray)
                }
            }
            
            switch viewModel.chosenBodyType {
            case .URLEncoded:
                urlEncodedParamsSection
            case .FormData:
                bodyFormDataParamsSection
            case .Binary:
                Text("Binary")
            case .Raw:
                Text("Raw")
            }
            
            Button(action: addBodyParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Spacer()
                    Text("Add \(viewModel.chosenBodyType.rawValue) Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
            
        } header: {
            Text("Body")
        }
    }
    
    private var urlEncodedParamsSection: some View {
        ForEach(viewModel.bodyEncodedQueryParams, id: \.self) {
            QueryParamItem(queryParam: $0)
        }
        .onDelete(perform: removeBodyParam)
    }
    
    private var bodyFormDataParamsSection: some View {
        ForEach(viewModel.bodyFormDataQueryParams, id: \.self) {
            QueryParamItem(queryParam: $0)
        }
        .onDelete(perform: removeBodyParam)
    }
    
    private func addBodyParam() {
        let queryParam = QueryParamEntity(context: moc)
        withAnimation {
            switch viewModel.chosenBodyType {
            case .URLEncoded:
                viewModel.bodyEncodedQueryParams.append(queryParam)
            case .FormData:
                viewModel.bodyFormDataQueryParams.append(queryParam)
            case .Binary:
                print("Binary")
            case .Raw:
                print("Raw")
            }
        }
    }
    
    private func removeBodyParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        switch viewModel.chosenBodyType {
        case .URLEncoded:
            viewModel.bodyEncodedQueryParams.remove(at: element)
        case .FormData:
            viewModel.bodyFormDataQueryParams.remove(at: element)
        default:
            print("")
        }
    }
    
    
    
    private func removeHeaderParam(_ offSet: IndexSet) {
        guard let element = offSet.first else { return }
        viewModel.headersParams.remove(at: element)
    }
    
    private func addHeaderParam() {
        let queryParam = QueryParamEntity(context: moc)
        withAnimation {
            viewModel.headersParams.append(queryParam)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                urlSection
                
                headerSection
                
                bodyContentSection
            }
            .listStyle(.sidebar)
            .navigationTitle("Create Request")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { presentationMode.wrappedValue.dismiss() } label: {
                        Text("Cancel")
                    }
                }
                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {  } label: {
//                        Text("Save")
//                            .font(.caption)
//                            .bold()
//                            .padding(9)
//                            .foregroundColor(.accentColor)
//                            .background(Color.accentColor.opacity(0.15))
//                            .cornerRadius(10)
//                    }
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {  } label: {
                        Image(systemName: "paperplane.fill")
                    }
                }
            }
        }
    }
}

struct CreateRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateRequestView(viewModel: CreateRequestViewModel())
                .environment(\.colorScheme, .light)
            
            CreateRequestView(viewModel: CreateRequestViewModel())
                .environment(\.colorScheme, .dark)
        }
    }
}

