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
    
    @ObservedObject var settingsObject = Settings.shared
    
    // MARK: Localization
    let about: LocalizedStringKey = "about"
    let settings: LocalizedStringKey = "settings"
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
                RadioPicker(options: [.list, .favorites], currentlySelected: $settingsObject.firstScreenSelection)
                
            }
            
        }.navigationBarTitle(Text(settings))
    }
}

struct AboutScreen: View {
    
    // MARK: Localization
    let about: LocalizedStringKey = "about"
    let love: LocalizedStringKey = "love"
    let description: LocalizedStringKey = "description"
    let website: LocalizedStringKey = "website"
    let credits: LocalizedStringKey = "credits"
    let entur: LocalizedStringKey = "entur"
    
    
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
        }.navigationBarTitle(Text(about))
    }
}

struct PremiumScreen: View {
    
    let premiumFavoritesProduct = StoreController.shared.premiumFavoritesProduct
    @ObservedObject var appState = AppState.shared
    
    // MARK: Localization
    let useful: LocalizedStringKey = "useful"
    let consider_upgrade: LocalizedStringKey = "consider_upgrade"
    let premium_favorites: LocalizedStringKey = "premium_favorites"
    let max_num_favorites: LocalizedStringKey = "max_num_favorites"
    let upgrade: LocalizedStringKey = "upgrade"
    let benefits: LocalizedStringKey = "benefits"
    let thank_you: LocalizedStringKey = "thank_you"
    let bought: LocalizedStringKey = "bought"
    let restore_string: LocalizedStringKey = "restore"
    
    var body: some View {
        ScrollView {
            
            // Show ad when user has not bought Premium Favorites
            !appState.hasPremiumFavorites
            ? Group {
                Text(useful).font(.headline)
                Spacer()
                Text(consider_upgrade)
                
                Divider().background(Color.red)
                
                Text(premium_favorites).font(.headline)
                Spacer()
                
                Text(max_num_favorites)
                Spacer(minLength: 20)
                Button(action: { self.buy(feature: UserDefaultsKeys.premiumFavoritesStatus.rawValue) }) {
                    VStack {
                        Text(upgrade)
                            .font(.headline)
                        Text("\(premiumFavoritesProduct?.regularPrice ?? "")")
                            .colorMultiply(.blue)
                    }
                    
                }
                Text(benefits)
            }
            : nil
            
            appState.hasPremiumFavorites
            ? Group {
                Text(thank_you).font(.headline)
                Spacer()
                Text(bought)
            }
            : nil
            
            Divider().background(Color.red)
            Spacer(minLength: 20)
        
            Button(action: {self.restore() }) {
                Text(restore_string)
            }
            
            
        }.onAppear(perform: { self.loadProducts() })
        .navigationBarTitle(Text("Premium"))
    }
    
    private func loadProducts() {
        StoreController.shared.fetchProductInformation()
    }
    
    private func restore() {
        StoreController.shared.restorePurchases()
    }
    
    private func buy(feature: String) {
        StoreController.shared.userWantsToBuy(feature: feature)
    }
    
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
            PremiumScreen()
        }.environment(\.locale, .init(identifier: "no"))
        
    }
}
