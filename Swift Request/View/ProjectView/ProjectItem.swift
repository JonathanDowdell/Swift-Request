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
            let systemIcon = project.systemIcon
            ZStack {
                Rectangle()
                    .foregroundColor(Color.accentColor.opacity(0.15))
                    .cornerRadius(10)
                    .frame(width: 40, height: 40, alignment: .center)
                
                Image(systemName: systemIcon)
                    .foregroundColor(Color.accentColor)
            }
            
            let name = project.name
            let version = project.version
            VStack(alignment: .leading) {
                Text(name)
                    .foregroundColor(.primary)
                Text(version)
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
