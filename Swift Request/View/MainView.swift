//
//  MainView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

struct MainView: View {
    
    @State private var searchText = ""
    
    @State private var list = Range(1...10)
    
    @State private var shouldPresentCompose = false
    
    var history: some View {
        Section {
            ForEach(list.prefix(3), id: \.self) { _ in
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
            ForEach(list.prefix(4), id: \.self) { _ in
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
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//
//                        } label: {
//                            Image(systemName: "line.3.horizontal.decrease.circle")
//                        }
//                    }
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            shouldPresentCompose = true
//                        } label: {
//                            Image(systemName: "folder")
//                        }
//                    }
//
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            shouldPresentCompose = true
//                        } label: {
//                            Image(systemName: "square.and.pencil")
//                        }
//                    }
                    
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button {
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
//                                Image(systemName: "gearshape")
                            }
                            
                            Button {
                            } label: {
                                Image(systemName: "folder")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Button {
                                shouldPresentCompose = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    }
                }
                .popover(isPresented: $shouldPresentCompose) {
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
