//
//  ProductsList.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 06/04/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import Foundation

class ProductList: ObservableObject {
    static let shared = ProductList()
    
    @Published var products: [String] = []
    
}
