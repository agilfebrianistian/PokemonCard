//
//  PokemonCardListParameter.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 26/02/26.
//

import Foundation


struct PokemonCardListParameter : Codable {
    var name: String?
    var paginationPage: Int
    var paginationItemsPerPage: Int

    enum CodingKeys: String, CodingKey {
        case name
        case paginationPage = "pagination:page"
        case paginationItemsPerPage = "pagination:itemsPerPage"
    }
    init(
        name: String? = nil,
        paginationPage: Int = 0,
        paginationItemsPerPage: Int = 8
    ) {
        self.name = name
        self.paginationPage = paginationPage
        self.paginationItemsPerPage = paginationItemsPerPage
    }
}
