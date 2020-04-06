//
//  HostingController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 20/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController : WKHostingController<ContentView> {
    
    override var body: ContentView {
        /*
        #if DEBUG
        StoreController.shared.setProductStatus(false, for: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
        #endif
        */
        LocationController.shared.enableBasicLocationServices()
        return ContentView()
    }
    
}

struct ContentView: View {
    
    var body: some View {
        StopsListView().environmentObject(AppState.shared)
        .environmentObject(FavoriteList())
    }
}
