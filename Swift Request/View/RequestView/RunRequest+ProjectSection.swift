//
//  RunRequest+ProjectSection.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/9/22.
//

import SwiftUI

extension RunRequestView {
    var projectSection: some View {
        NavigationLink {
            CreateRequestProjectView(request: $vm.savedRequest, selectedProject: $vm.selectedProject)
                .onAppear {
                    vm.shouldUpdate = true
                }
                .onDisappear {
                    vm.shouldUpdate = false
                }
        } label: {
            
            let name = vm.selectedProject?.name ?? ""
            let folderIconColor: Color = vm.selectedProject == nil ? .gray : .accentColor
            
            HStack {
                Image(systemName: "folder")
                    .padding(.trailing, 14)
                    .foregroundColor(folderIconColor)
                Text("Project")
                    .foregroundColor(.gray)
                Spacer()
                Text(name)
                    .foregroundColor(.accentColor)
            }
            .tint(Color.accentColor)
        }
        .accessibilityIdentifier("projectSelectionBtn")
    }
}
