//
//  SettingsView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 16/10/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @ObservedObject var settings = Settings.shared
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: AboutScreen()) {
                Text("Om denne appen")
                    
            }
            Button("Hjelp") {
                
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Startskjerm").font(.headline)
                RadioPicker(options: [.list, .closest, .favorites], currentlySelected: $settings.firstScreenSelection)
                
            }
            
        }
    }
}

struct AboutScreen: View {
    var body: some View {
        ScrollView {
            Text("Denne appen er utviklet av Håkon Strandlie. Tilbakemeldinger og rapportering av bugs settes alltid pris på, og kan gjøres gjennom www.strandlie.co/ferd")
                
            Divider()
            VStack(alignment: .leading) {
                Text("Kreditering").font(.headline)
                Text("Data hentes fra EnTur. developer.entur.org")
                Spacer()
                Text("AlamoFire brukes til nettverkskall")
            }
            
            Group {
                HStack {
                    IconController.getIcon(for: .bus)
                    Text("Icon made by Kirill Kazachek from www.flaticon.com")
                }
                HStack {
                    IconController.getIcon(for: .tram)
                    Text("Icon made by Freepik from www.flaticon.com")
                }
                HStack {
                    IconController.getIcon(for: .metro)
                    Text("Icon made by Freepik from www.flaticon.com")
                }
                HStack {
                    IconController.getIcon(for: .train)
                    Text("Icon made by Freepik from www.flaticon.com")
                }
                HStack {
                    IconController.getIcon(for: .airport)
                    Text("Icon made by Freepik from www.flaticon.com")
                }
                HStack {
                    IconController.getIcon(for: .ferry)
                    Text("Icon made by Smashicons from www.flaticon.com")
                }
            }
        }
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
            AboutScreen()
        }
        
    }
}
