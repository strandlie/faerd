//
//  AppExtensions.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 05/04/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import Foundation

extension ProductIdentifiers {
    var identifiers: [String]? {
        guard let path = Bundle.main.path(forResource: self.name, ofType: self.fileExtension) else { return nil }
        return NSArray(contentsOfFile: path) as? [String]
    }
}
