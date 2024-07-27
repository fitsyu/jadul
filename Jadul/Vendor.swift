//
//  Vendor.swift
//  Jadul
//
//  Created by Fitsyu  on 27/07/24.
//

import Foundation

struct Vendor: Decodable {
    let id: Int
    let name: String
    let audio: URL
    
    let items: [Item]
    let locationTime: [LocationTime]
    
    struct Item: Decodable {
        let id: Int
        let name: String
        let price: Int
    }
    
    struct LocationTime: Decodable {
        let lat: Double
        let lng: Double
        let time: String?
    }
}
