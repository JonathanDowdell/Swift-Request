//
//  RunRequest+BodyContent.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/21/21.
//

import SwiftUI

extension RunRequestView {
    
    var bodyContentSection: some View {
        Section {
            Picker(selection: $vm.bodyContentType) {
                ForEach(BodyType.allCases, id: \.self) {
                    let method = $0
                    Text(method.rawValue)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .padding(.horizontal, 3)
                        .foregroundColor(method.color().primary)
                        .background(method.color().secondary)
                        .cornerRadius(10)
                }
            } label: {
                let active = (!vm.bodyQueryParams.isEmpty)
                
                HStack {
                    Image(systemName: "shippingbox")
                        .padding(.trailing, 14)
                        .foregroundColor(active ? Color.accentColor : Color.gray)
                    Text("Content")
                        .foregroundColor(.gray)
                }
            }
            
            switch vm.bodyContentType {
            case .FormURLEncoded, .MultipartFormData:
                bodyParamsSection
            case .JSON:
                Text("JSON")
            case .XML:
                Text("XML")
            case .Binary:
                Text("Binary")
            case .Raw:
                Text("Raw")
            }
            
            Button(action: addBodyParam) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Spacer()
                    Text("Add \(vm.bodyContentType.rawValue) Param")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            }
            
        } header: {
            Text("Body")
        }
    }
    
    private var bodyParamsSection: some View {
        ForEach(vm.bodyQueryParams, id: \.self) {
            ParamItem($0)
        }
        .onDelete(perform: removeBodyParam)
    }
    
    private func addBodyParam() {
        let queryParam = ParamEntity(context: moc)
        queryParam.type = ParamType.Body.rawValue
        queryParam.active = true
        withAnimation {
            switch vm.bodyContentType {
            case .FormURLEncoded, .MultipartFormData:
                vm.bodyQueryParams.append(queryParam)
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
    
    private func removeBodyParam(_ offSet: IndexSet) {
        for index in offSet {
            let element = vm.bodyQueryParams[index]
            moc.delete(element)
        }
        vm.bodyQueryParams.remove(atOffsets: offSet)
        try? moc.save()
//        guard let element = offSet.first else { return }
//        switch vm.bodyContentType {
//        case .FormURLEncoded:
//            let param = vm.bodyQueryParams[element]
//            moc.delete(param)
//            vm.bodyQueryParams.remove(at: element)
//        default:
//            print("")
//        }
//        try? moc.save()
    }
}

struct RunRequestView_BodyContentSection_Previews: PreviewProvider {
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
