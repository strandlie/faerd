//
//  AppDataTypes.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 05/04/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import Foundation

struct ProductIdentifiers {
    /// Name of the resource file containing the product identifiers
    let name = "ProductIds"
    /// Filename extension of the resource file containing the product identifiers
    let fileExtension = "plist"
}

/// A structure that is used to represent a list of products or purchases.
struct Section {
    /// Products/Purchases are organized by category
    var type: SectionType
    /// List of products/purchases
    var elements = [Any]()
}

enum SectionType: String {
    case availableProducts = "AVAILABLE PRODUCTS"
    case invalidProductIdentifiers = "INVALID PRODUCT IDENTIFIERS"
    case purchased = "PURCHASED"
    case restored = "RESTORED"
}
