//
//  ProjectItem.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/23/21.
//

import SwiftUI

struct ProjectItem<Label: View>: View {
    
    @ObservedObject var project: ProjectEntity
    
    let label: Label
    
    init(project: ProjectEntity, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.project = project
    }
    
    var body: some View {
        HStack {
            Image(systemName: project.wrappedSystemIcon)
                .padding(.horizontal, 11)
                .padding(.vertical, 10)
                .foregroundColor(Color.cyan)
                .background(Color.cyan.opacity(0.15))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(project.wrappedName)
                    .foregroundColor(.primary)
                Text(project.wrappedVersion)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .tint(Color.gray)
            }
            
            label
        }
    }
}


extension ProjectItem where Label == EmptyView {
    init(project: ProjectEntity) {
        self.init(project: project, label: {EmptyView()})
    }
}

//struct ProjectItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectItem(project: <#ProjectEntity#>)
//    }
//}
