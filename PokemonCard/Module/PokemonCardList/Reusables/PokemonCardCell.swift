//
//  PokemonCardCell.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 06/02/26.
//

import UIKit
import SDWebImage

class PokemonCardCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    func configure(with pokemon: PokemonCardListResponse) {
        imageView.sd_setImage(with: URL(string: "\(pokemon.image ?? "")/high.webp"),
                              placeholderImage: UIImage(named: "pokemonCardPlaceholder"))
    }

}
