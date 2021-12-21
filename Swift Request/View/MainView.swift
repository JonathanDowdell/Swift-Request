//
//  MainView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var list = Range(1...10)
    @Published var shouldPresentCompose = false
    @Published var toolbarItemLeadingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var toolbarItemTrailingPlacement: ToolbarItemPlacement = .bottomBar
    @Published var layout: Layout = .bottom
 
    
    enum Layout: String {
    case top, bottom
    }
    
    func changeToolbarLayout() {
        if layout == .bottom {
            toolbarItemLeadingPlacement = .navigationBarLeading
            toolbarItemTrailingPlacement = .navigationBarTrailing
            layout = .top
        } else {
            toolbarItemLeadingPlacement = .bottomBar
            toolbarItemTrailingPlacement = .bottomBar
            layout = .bottom
        }
    }
}


struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var history: some View {
        Section {
            ForEach(viewModel.list.prefix(3), id: \.self) { _ in
                NavigationLink {
                    EmptyView()
                } label: {
                    RequestItem()
                }
            }
            .onDelete { _ in

            }
        } header: {
            Text("History")
        }
    }
    
    var projects: some View {
        Section {
            ForEach(viewModel.list.prefix(4), id: \.self) { _ in
                NavigationLink {
                    EmptyView()
                } label: {
                    HStack {
                        Image(systemName: "network")
                            .padding(.horizontal, 11)
                            .padding(.vertical, 10)
                            .foregroundColor(Color.cyan)
                            .background(Color.cyan.opacity(0.15))
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading) {
                            Text("Social Setting")
                            Text("Version 1.0")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .tint(Color.gray)
                        }
                    }
                }
            }
        } header: {
            Text("Projects")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    projects
                    
                    history
                }
                .navigationTitle("Requests")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                .toolbar {
                    ToolbarItem(placement: viewModel.toolbarItemLeadingPlacement) {
                        HStack {
                            Button {
                                viewModel.changeToolbarLayout()
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                            
                            if viewModel.layout == .bottom {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "folder.badge.plus")
                                }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: viewModel.toolbarItemTrailingPlacement) {
                        HStack {
                            if viewModel.layout == .top {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "folder.badge.plus")
                                }
                            }
                            
                            Button {
                                viewModel.shouldPresentCompose = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                }
                .popover(isPresented: $viewModel.shouldPresentCompose) {
                    CreateRequestView(viewModel: CreateRequestViewModel())
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environment(\.colorScheme, .light)
            
            MainView()
                .environment(\.colorScheme, .dark)
        }
    }
}


