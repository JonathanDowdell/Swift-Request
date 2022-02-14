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
            if let firstSortedResponse = vm.responses.sorted(by: { $0.creationDate > $1.creationDate }).first {
                Section {
                    NavigationLink {
                        ResponseView(response: firstSortedResponse)
                            .onAppear {
                                vm.shouldUpdate = false
                            }
                            .onDisappear {
                                vm.shouldUpdate = true
                            }
                    } label: {
                        ResponseItem(response: firstSortedResponse)
                    }
                    .foregroundColor(.gray)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            withAnimation {
                                vm.removeResponse(firstSortedResponse)
                            }
                        } label: {
                            Text("Delete")
                        }
                        .tint(.red)

                    }
                    
                    let moreThanOneResponse: Bool = vm.responses.count > 1
                    
                    if moreThanOneResponse {
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

