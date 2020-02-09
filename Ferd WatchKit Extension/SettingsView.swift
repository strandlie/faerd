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
    
    // MARK: Localization
    let about: LocalizedStringKey = "about"
    let premium_features: LocalizedStringKey = "premium_features"
    let start_screen: LocalizedStringKey = "start_screen"
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: AboutScreen()) {
                Text(about)
                    
            }
            NavigationLink(destination: PremiumScreen()) {
                Text(premium_features)
            }

            Spacer()
            VStack(alignment: .leading) {
                Text(start_screen).font(.headline)
                RadioPicker(options: [.list, .favorites], currentlySelected: $settings.firstScreenSelection)
                
            }
            
        }
    }
}

struct AboutScreen: View {
    
    // MARK: Localization
    let love: LocalizedStringKey = "love"
    let description: LocalizedStringKey = "description"
    let website: LocalizedStringKey = "website"
    let credits: LocalizedStringKey = "credits"
    let entur: LocalizedStringKey = "entur"
    let alamofire: LocalizedStringKey = "alamofire"
    let settings: LocalizedStringKey = "settings"
    
    var body: some View {
        ScrollView {
            Image("Logo")
            Text(description)
                .font(.caption)
            Text(website)
                .font(.caption)
                .kerning(2)
                .padding(.top)

                
            Divider()
            VStack(alignment: .leading) {
                Text(credits).font(.headline)
                Text(entur)
                Spacer()
                Text(alamofire)
            }
            
            Divider()
            Group {
                HStack {
                    IconController.getIcon(for: BusStop.StopType.bus.rawValue)
                    Text("Icon made by Kirill Kazachek from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: BusStop.StopType.tram.rawValue)
                    Text("Icon made by Freepik from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: BusStop.StopType.metro.rawValue)
                    Text("Icon made by Freepik from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: BusStop.StopType.train.rawValue)
                    Text("Icon made by Freepik from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: BusStop.StopType.airport.rawValue)
                    Text("Icon made by Freepik from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: BusStop.StopType.ferry.rawValue)
                    Text("Icon made by Smashicons from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: BusStop.StopType.lift.rawValue)
                    Text("Icon made by Made from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: Favorite.FavoriteType.stop.rawValue)
                    Text("Icon made by Freepik from www.flaticon.com")
                    Spacer()
                }
                HStack {
                    IconController.getIcon(for: Favorite.FavoriteType.departure.rawValue)
                    Text("Icon made by Freepik from www.flaticon.com")
                    Spacer()
                }
            }
        }.navigationBarTitle(settings)
    }
}

struct PremiumScreen: View {
    var body: some View {
        EmptyView()
    }
    
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
            AboutScreen()
        }.environment(\.locale, .init(identifier: "no"))
        
    }
}
