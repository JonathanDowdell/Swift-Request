//
//  CreateRequestProjectView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/22/21.
//

import SwiftUI
import CoreData

class CreateRequestProjectViewModel: ObservableObject {
    
    @Published var creating = false
    
    @Published var name = ""
    
    @Published var version = ""
    
    @Published var projectIcon = "network"
    
    @Published var wiggling = false
    
    @Published var color = Color.cyan
    
    @Published var slideOverCard = false
    
}

struct CreateRequestProjectView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Binding var request: RequestEntity?
    
    @Binding var selectedProject: ProjectEntity?
    
    @StateObject var vm = CreateRequestProjectViewModel()
    
    @FetchRequest(entity: ProjectEntity.entity(), sortDescriptors: []) private var projects: FetchedResults<ProjectEntity>
    
    @Environment(\.presentationMode) var presentationMode
    
    fileprivate func wiggleIcon() {
        self.vm.wiggling.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.vm.wiggling.toggle()
        }
    }
    
    fileprivate func showCreateProjectSection() {
        withAnimation(.easeInOut(duration: 0.2)) {
            vm.creating = true
            selectedProject = nil
        }
    }
    
    fileprivate func showProjects(project: ProjectEntity) {
        withAnimation {
            if selectedProject == project {
                selectedProject = nil
            } else {
                selectedProject = project
            }
            vm.creating = false
        }
        request?.project = selectedProject
    }
    
    fileprivate func showIconSelection() {
        vm.slideOverCard = true
    }
    
    var body: some View {
        List {
            let isCreatingProject = !vm.creating
            if isCreatingProject {
                Button {
                    withAnimation {
                        vm.creating = true
                    }
                } label: {
                    Text("New")
                }
            }
            
            if vm.creating {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Fancy Project Name", text: $vm.name)
                            .multilineTextAlignment(.trailing)
                    }
                    .onTapGesture(perform: wiggleIcon)
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        TextField("Version 1.0", text: $vm.version)
                            .multilineTextAlignment(.trailing)
                    }
                    .onTapGesture(perform: wiggleIcon)
                    
                    Button {
                        showCreateProjectSection()
                    } label: {
                        HStack {
                            Button {
                                showIconSelection()
                            } label: {
                                Image(systemName: "network")
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 10)
                                    .foregroundColor(Color.cyan)
                                    .background(Color.cyan.opacity(0.15))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .rotationEffect(.degrees(vm.wiggling ? 3.5 : 1))
                            .scaleEffect(vm.wiggling ? 1.2 : 1)
                            .animation(Animation.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true), value: vm.wiggling)
                            
                            VStack(alignment: .leading) {
                                Text(vm.name.isEmpty ? "Fancy Project Name" : vm.name)
                                    .foregroundColor(.primary)
                                Text(vm.version.isEmpty ? "Version 1.0" : vm.version)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .tint(Color.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding(.vertical, 5)
                    
                    
                } header: {
                    Text("Create Project")
                }
            }
            
            
            
            Section {
                ForEach(projects, id: \.self) { project in
                    Button {
                        showProjects(project: project)
                    } label: {
                        HStack {
                            ProjectItem(project: project) {
                                if selectedProject == project && !vm.creating {
                                    Spacer()
                                    
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 5)
                
            } header: {}
        }
        .popover(isPresented: $vm.slideOverCard) {
            IconsView(projectIcon: $vm.projectIcon)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if vm.creating {
                    PillButton {
                        let project = ProjectEntity(context: moc)
                        project.raw_creation_date = Date()
                        project.raw_name = vm.name
                        project.raw_system_icon = vm.projectIcon
                        project.raw_version = vm.version
                        self.selectedProject = project
                        if let request = request {
                            self.selectedProject?.addToRequests(request)
                        }
                        try? moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } content: {
                        Text("Save")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .navigationTitle("Projects")
    }
}

struct CreateRequestProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateRequestProjectView(request: .constant(nil), selectedProject: .constant(nil))
        }
    }
}


struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
