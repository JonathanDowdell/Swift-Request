//
//  SettingsView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/15/22.
//

import SwiftUI

enum SystemColorValue: String, CaseIterable {
    case System, Light, Dark
    
    func value() -> ColorScheme? {
        switch self {
        case .System:
            return nil
        case .Light:
            return .light
        case .Dark:
            return .dark
        }
    }
}

enum TintColorValue: CaseIterable {
    case Blue, Green, Red, Cyan, Pink, Orange
    
    func value() -> Color {
        switch self {
        case .Blue:
            return .blue
        case .Green:
            return .green
        case .Red:
            return .red
        case .Cyan:
            return .cyan
        case .Pink:
            return .pink
        case .Orange:
            return .orange
        }
    }
}

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var setting: SettingEntity
    
    var appearanceSection: some View {
        Section("Appearance") {
            Picker(selection: .init(get: {
                return Int(setting.themeIndex)
            }, set: { value in
                setting.themeIndex = Int16(value)
            })) {
                ForEach(0 ..< SystemColorValue.allCases.count, id: \.self) {
                    Text(SystemColorValue.allCases[$0].rawValue)
                }
            } label: {
                Text("Theme")
            }
            
            Picker(selection: .init(get: {
                return Int(setting.tintIndex)
            }, set: { value in
                setting.tintIndex = Int16(value)
            })) {
                ForEach(0 ..< TintColorValue.allCases.count, id: \.self) {
                    Text(TintColorValue.allCases[$0].value().description.capitalizingFirstLetter())
                }
            } label: {
                Text("Tint")
            }

        }
        .onAppear {
            try? moc.save()
        }
    }
    
    var supportSection: some View {
        Section("Support") {
            
            Button {
                
            } label: {
                HStack {
                    Text("Share")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Text("Feedback")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "envelope")
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Text("Help")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "globe")
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
        }
        
    }
    
    var aboutSection: some View {
        Section {
            NavigationLink {
                EmptyView()
            } label: {
                Text("Acknowledgements")
            }

            HStack {
                Text("Version")
                Spacer()
                Text("1.0")
                    .foregroundColor(.gray)
            }
        } header: {
            Text("About")
        } footer: {
            Text("Made with ❤️ by Jonathan D.")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                appearanceSection
                
                supportSection
                
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
