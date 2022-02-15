//
//  MainViewModel.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/26/21.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var vm: MainViewModel
    
    @FetchRequest(sortDescriptors: [], animation: .default) var settings: FetchedResults<SettingEntity>
    
    @Environment(\.managedObjectContext) var moc
    
    var setting: SettingEntity {
        if let setting = settings.first {
            return setting
        } else {
            return SettingEntity(context: moc)
        }
    }
    
    var projectSection: some View {
        Section {
            
            let filteredProjects = vm.filteredProjects
            
            ForEach(filteredProjects, id: \.self) { project in
                NavigationLink {
                    ProjectView(vm: ProjectViewModel(project, context: moc))
                } label: {
                    ProjectItem(project: project)
                }
                .contextMenu {
                    Button {vm.duplicateProject(project)} label: {
                        Text("Duplicate")
                    }
                    
                    Button {vm.deleteProject(project)} label: {
                        Text("Delete")
                    }
                }
            }
            .onDelete { offSet in
                vm.deleteProject(offSet)
            }
        } header: {
            Text("Projects")
        }
    }
    
    var historySection: some View {
        Section {
            
            let requestHistory = vm.requestHistory
            
            ForEach(requestHistory, id: \.self) { request in
                NavigationLink {
                    RunRequestView(vm: RunRequestViewModel(request: request, context: moc),
                                   requestsManager: vm)
                } label: {
                    RequestItem(request: request)
                }
            }
            .onDelete { offSet in
                vm.deleteRequest(offSet)
            }
        } header: {
            Text("History")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    projectSection
                    
                    historySection
                }
                .accessibilityIdentifier("mainSection")
                .navigationTitle("Requests")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                .toolbar {
                    ToolbarItem(placement: vm.toolbarItemLeadingPlacement) {
                        
                        let isBottomLayout = vm.layout == .bottom
                        
                        HStack {
                            Button {
                                vm.shouldPopOverSettings.toggle()
                            } label: {
                                Image(systemName: "gearshape.fill")
                            }

                            
                            if isBottomLayout {
                                Button {
                                    vm.shouldPresentNewProject = true
                                } label: {
                                    Image(systemName: "folder.badge.plus")
                                }
                                .accessibility(identifier: "composeProject")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: vm.toolbarItemTrailingPlacement) {
                        HStack(spacing: 20) {
                            Button {vm.shouldPresentCompose = true} label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .accessibility(identifier: "composeRequest")
                        }
                    }
                }
                .popover(isPresented: $vm.shouldPresentCompose) {
                    NavigationView {
                        RunRequestView(vm: RunRequestViewModel(context: moc), requestsManager: vm)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button { vm.shouldPresentCompose = false } label: {
                                        Text("Close")
                                    }
                                    .accessibility(identifier: "closeRequestBtn")
                                }
                            }
                    }
                }
                .popover(isPresented: $vm.shouldPresentNewProject) {
                    CreateProjectView(vm: CreateProjectViewModel(moc: moc), previousVm: vm)
                }
            }
            .onAppear {
                vm.reload()
            }
        }
    }
}

struct MainViewAlt_Previews: PreviewProvider {
    static var previews: some View {
        MainView(vm: MainViewModel(context: PersistenceController.shared.container.viewContext))
    }
}
