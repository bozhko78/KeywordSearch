//
//  Models.swift
//  KeywordSearch
//
//  Created by Bozhko Terziev on 16.08.20.
//  Copyright © 2020 Softavail. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let data:[Vehicle]
    let included:[Extra]
}

struct Vehicle: Codable {
    let id:String
    let type:String
    let attributes:VehicleAttributes
    let relationships:Relationsheap
}

// MARK: Attributes
struct VehicleAttributes: Codable {
    let name:String
}

// MARK: Relationsheap
struct Relationsheap: Codable {
    let images:Images
    let owner:Owner
    let primary_image:PrimaryImage
}

struct Images: Codable {
    let data: [BaseData]
}

struct Owner: Codable {
    let data: BaseData
}

struct PrimaryImage: Codable {
    let data: BaseData
}

struct BaseData: Codable {
    let id: String
    let type: String
}

// MARK: Included
struct Extra: Codable {
    let id:String
    let type:String
    let attributes:Attributes
}

struct Attributes: Codable {
    let url:String
    let tags: String
    let description:String
}

