//
//  PokemonCardDetailResponse.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 26/02/26.
//

import Foundation

struct PokemonCardDetailResponse: Codable {
    let category: String?
    let id: String?
    let illustrator: String?
    let image: String?
    let localId: String?
    let name: String?
    let rarity: String?
    let set: PokemonSet?
    let variants: PokemonVariants?
    let hp: Int?
    let types: [String]?
    let evolveFrom: String?
    let description: String?
    let stage: String?
    let attacks: [PokemonAttack]?
    let weaknesses: [PokemonWeakness]?
    let retreat: Int?
    let regulationMark: String?
    let legal: PokemonLegal?
}

struct PokemonSet: Codable {
    let cardCount: PokemonCardCount?
    let id: String?
    let logo: String?
    let name: String?
    let symbol: String?
}

struct PokemonCardCount: Codable {
    let official: Int?
    let total: Int?
}

struct PokemonVariants: Codable {
    let firstEdition: Bool?
    let holo: Bool?
    let normal: Bool?
    let reverse: Bool?
    let wPromo: Bool?
}

struct PokemonAttack: Codable {
    let cost: [String]?
    let name: String?
    let effect: String?
    let damage: String?
    
    enum CodingKeys: String, CodingKey {
        case cost, name, effect, damage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cost = try container.decodeIfPresent([String].self, forKey: .cost)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        effect = try container.decodeIfPresent(String.self, forKey: .effect)
        
        if let intDamage = try? container.decode(Int.self, forKey: .damage) {
            damage = "\(intDamage)"
        } else if let stringDamage = try? container.decode(String.self, forKey: .damage) {
            damage = stringDamage
        } else {
            damage = nil
        }
    }
}

struct PokemonWeakness: Codable {
    let type: String?
    let value: String?
}

struct PokemonLegal: Codable {
    let standard: Bool?
    let expanded: Bool?
}
