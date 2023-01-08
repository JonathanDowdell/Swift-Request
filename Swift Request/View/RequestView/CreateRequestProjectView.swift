//
//  CreateRequestProjectView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/22/21.
//

import SwiftUI

struct CreateRequestProjectView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: ProjectEntity.entity(), sortDescriptors: []) private var projects: FetchedResults<ProjectEntity>
    
    @Binding private(set) var request: RequestEntity?
    
    @Binding private(set) var selectedProject: ProjectEntity?
    
    @State private var projectToSet: ProjectEntity?
    
    @State private var creating = false
    
    @State private var name = ""
    
    @State private var version = ""
    
    @State private var projectIcon = "network"
    
    @State private var wiggling = false
    
    @State private var color = Color.cyan
    
    @State private var slideOverCard = false
    
    private func wiggleIcon() {
        self.wiggling.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.wiggling.toggle()
        }
    }
    
    private func showCreateProjectSection() {
        withAnimation(.easeInOut(duration: 0.2)) {
            creating = true
            selectedProject = nil
        }
    }
    
    private func selectProject(project: ProjectEntity) {
        withAnimation {
            if projectToSet == project {
                projectToSet = nil
            } else {
                projectToSet = project
            }
            
            creating = false
        }
    }
    
    private func showIconSelection() {
        slideOverCard = true
    }
    
    private func saveProject() {
        let project = ProjectEntity(context: moc)
        project.raw_creation_date = Date()
        project.raw_name = name
        project.raw_system_icon = projectIcon
        project.raw_version = version
        self.selectedProject = project
        if let request = request {
            self.selectedProject?.addToRequests(request)
        }
        try? moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        List {
            let isCreatingProject = !creating
            if isCreatingProject {
                Button {
                    withAnimation {
                        creating = true
                    }
                } label: {
                    Text("New")
                }
            }
            
            if creating {
                projectCreationSection
            }
            
            projectSelectionSection
        }
        .popover(isPresented: $slideOverCard) {
            IconsView(projectIcon: $projectIcon)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if creating {
                    PillButton {
                        saveProject()
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
        .onDisappear {
            if let projectToSet = projectToSet {
                request?.project = projectToSet
                selectedProject = projectToSet
            }
        }
    }
}

struct CreateRequestProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateRequestProjectView(request: .constant(nil), selectedProject: .constant(nil))
        }
    }
}

extension CreateRequestProjectView {
    private var projectCreationSection: some View {
        Section {
            HStack {
                Text("Name")
                Spacer()
                TextField("Fancy Project Name", text: $name)
                    .multilineTextAlignment(.trailing)
            }
            .onTapGesture(perform: wiggleIcon)
            
            HStack {
                Text("Version")
                Spacer()
                TextField("Version 1.0", text: $version)
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
                    .rotationEffect(.degrees(wiggling ? 3.5 : 1))
                    .scaleEffect(wiggling ? 1.2 : 1)
                    .animation(Animation.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true), value: wiggling)
                    
                    VStack(alignment: .leading) {
                        Text(name.isEmpty ? "Fancy Project Name" : name)
                            .foregroundColor(.primary)
                        Text(version.isEmpty ? "Version 1.0" : version)
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
    
    private var projectSelectionSection: some View {
        Section {
            ForEach(projects, id: \.self) { project in
                Button {
                    selectProject(project: project)
                } label: {
                    HStack {
                        ProjectItem(project: project) {
                            if (selectedProject == project || projectToSet == project) && !creating {
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
