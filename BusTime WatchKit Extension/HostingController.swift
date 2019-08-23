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

class HostingController : WKHostingController<StopsListView> {    
    
    override var body: StopsListView {
        LocationController.shared.enableBasicLocationServices()
        return StopsListView(user: User.shared)
    }
    
    
}
