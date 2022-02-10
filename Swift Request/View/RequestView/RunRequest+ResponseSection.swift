//
//  RunRequest+ResponseSection.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/9/22.
//

import SwiftUI

extension RunRequestView {
    var responseSection: some View {
        Group {
            if let response = vm.responses.sorted(by: { $0.creationDate > $1.creationDate }).first {
                Section {
                    NavigationLink {
                        ResponseView(response: response)
                            .onAppear {
                                vm.shouldUpdate = false
                            }
                            .onDisappear {
                                vm.shouldUpdate = true
                            }
                    } label: {
                        ResponseItem(response: response)
                    }
                    .foregroundColor(.gray)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            withAnimation {
                                vm.removeResponse(response)
                            }
                        } label: {
                            Text("Delete")
                        }
                        .tint(.red)

                    }
                    
                    if vm.responses.count > 1 {
                        NavigationLink {
                            ResponseListView(vm: vm)
                                .onAppear {
                                    vm.shouldUpdate = false
                                }
                                .onDisappear {
                                    vm.shouldUpdate = true
                                }
                        } label: {
                            HStack {
                                Image(systemName: "list.bullet.rectangle")
                                    .foregroundColor(.accentColor)
                                Text("See All")
                                    .padding(.leading, 15)
                                    .foregroundColor(.primary)
                            }
                        }
                        .foregroundColor(.gray)
                    }
                } header: {
                    Text("Response")
                }
            }
        }
    }
}

