//
//  CreateRequestView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

class CreateRequestViewModel: ObservableObject {
    
    // MARK: URL
    @Published var title = ""
    @Published var url = ""
    @Published var urlParams = [ParamEntity]()
    @Published var methodSelection: MethodType = .GET
    var methodOptions = MethodType.allCases
    
    // MARK: Header
    @Published var headerParams = [ParamEntity]()
    
    // MARK: Body
    @Published var bodyContentType: BodyType = .FormURLEncoded
    @Published var bodyEncodedQueryParams = [ParamEntity]()
    @Published var bodyFormDataQueryParams = [ParamEntity]()
    var bodyTypeOptions = BodyType.allCases
}

struct CreateRequestView: View {
    
    @StateObject var viewModel: CreateRequestViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            List {
                urlSection
                
                headerSection
                
                bodyContentSection
            }
            .listStyle(.sidebar)
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
            .navigationTitle("Create Request")
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




