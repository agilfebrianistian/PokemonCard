//
//  PokemonCardDetailViewModel.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 06/02/26.
//

import Foundation
import PromiseKit

final class PokemonCardDetailViewModel {
    
    var pokemon: PokemonCardDetailResponse?
    
    var onDataUpdated: (() -> Void)?
    var onShowAlert: ((NetworkError) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private var isLoading = false
    
    func fetchDetail(cardId: String) {
        guard !isLoading else { return }
        isLoading = true
        onLoadingStateChanged?(true)
        
        let target = NetworkAPI.getPokemonCardDetail(cardId: cardId)
        let future = NetworkFuture<Data>()
        
        future.request(target: target)
            .done { [weak self] data in
                guard let self = self else { return }
                
                let decoder = JSONDecoder()
                let result = try decoder.decode(PokemonCardDetailResponse.self, from: data)
                
                self.pokemon = result
                self.isLoading = false
                
                DispatchQueue.main.async {
                    self.onLoadingStateChanged?(false)
                    self.onDataUpdated?()
                }
            }
            .catch { [weak self] error in
                self?.isLoading = false
                
                DispatchQueue.main.async {
                    self?.onLoadingStateChanged?(false)
                    self?.onShowAlert?(error as? NetworkError ?? NetworkError())
                }
            }
    }
}
