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
            CreateRequestProjectView(selectedProject: $vm.selectedProject)
                .onAppear {
                    vm.shouldUpdate = false
                }
                .onDisappear {
                    vm.shouldUpdate = true
                }
        } label: {
            let name = vm.selectedProject?.wrappedName ?? ""
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
        .accessibilityIdentifier("projectSelectionBtn")
    }
}
