//
//  GlobalThemeView.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 2/15/22.
//

import SwiftUI

struct GlobalThemeView: View {
    
    @StateObject var mainViewModel: MainViewModel
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var settings: FetchedResults<SettingEntity>
    
    @Environment(\.managedObjectContext)
    private var moc
    
    private var setting: SettingEntity {
        if let setting = settings.first {
            return setting
        } else {
            return SettingEntity(context: moc)
        }
    }
    
    
    var body: some View {
        MainView(vm: mainViewModel)
            .preferredColorScheme(SystemColorValue.allCases[Int(setting.themeIndex)].value())
            .accentColor(TintColorValue.allCases[Int(setting.tintIndex)].value())
            .popover(isPresented: $mainViewModel.shouldPopOverSettings) {
                SettingsView(setting: setting)
                    .preferredColorScheme(SystemColorValue.allCases[Int(setting.themeIndex)].value())
                    .accentColor(TintColorValue.allCases[Int(setting.tintIndex)].value())
            }
    }
}

struct GlobalThemView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalThemeView(mainViewModel: MainViewModel())
    }
}
