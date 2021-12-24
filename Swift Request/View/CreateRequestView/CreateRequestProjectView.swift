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
    
    @Binding var selectedProject: ProjectEntity?
    
    @StateObject var viewModel = CreateRequestProjectViewModel()
    
    @FetchRequest(entity: ProjectEntity.entity(), sortDescriptors: []) private var projects: FetchedResults<ProjectEntity>
    
    @Environment(\.presentationMode) var presentationMode
    
    fileprivate func wiggleIcon() {
        self.viewModel.wiggling.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.viewModel.wiggling.toggle()
        }
    }
    
    fileprivate func showCreateProjectSection() {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.creating = true
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
            viewModel.creating = false
        }
    }
    
    fileprivate func showIconSelection() {
        viewModel.slideOverCard = true
    }
    
    var body: some View {
        List {
            if !viewModel.creating {
                Button {
                    withAnimation {
                        viewModel.creating = true
                    }
                } label: {
                    Text("New")
                }
            }
            
            if viewModel.creating {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Fancy Project Name", text: $viewModel.name)
                            .multilineTextAlignment(.trailing)
                    }
                    .onTapGesture(perform: wiggleIcon)
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        TextField("Version 1.0", text: $viewModel.version)
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
                            .rotationEffect(.degrees(viewModel.wiggling ? 3.5 : 1))
                            .scaleEffect(viewModel.wiggling ? 1.2 : 1)
                            .animation(Animation.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true), value: viewModel.wiggling)
                            
                            VStack(alignment: .leading) {
                                Text(viewModel.name.isEmpty ? "Fancy Project Name" : viewModel.name)
                                    .foregroundColor(.primary)
                                Text(viewModel.version.isEmpty ? "Version 1.0" : viewModel.version)
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
                                if selectedProject == project && !viewModel.creating {
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
        .popover(isPresented: $viewModel.slideOverCard) {
            IconsView(projectIcon: $viewModel.projectIcon)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.creating {
                    PillButton {
                        let project = ProjectEntity(context: moc)
                        project.creationDate = Date()
                        project.name = viewModel.name
                        project.systemIcon = viewModel.projectIcon
                        project.version = viewModel.version
                        self.selectedProject = project
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
            CreateRequestProjectView(selectedProject: .constant(nil))
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
