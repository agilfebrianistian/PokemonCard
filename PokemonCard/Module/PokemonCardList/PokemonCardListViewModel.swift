//
//  PokemonCardListViewModel.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 26/02/26.
//

import Foundation
import PromiseKit

class PokemonCardListViewModel {
    
    var items: [PokemonCardListResponse] = []
    private var currentQuery = PokemonCardListParameter()
    private var isLoading = false
    private var hasMorePages = true
    
    var onDataUpdated: (() -> Void)?
    var onShowAlert: ((NetworkError) -> Void)?
    var onEmptyResult: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    func search( name: String? = nil) {
        items.removeAll()
        currentQuery = PokemonCardListParameter(
            name: name,
            paginationPage: 0,
            paginationItemsPerPage: 8
        )
        
        hasMorePages = true
        isLoading = false
        
        fetchNext()
    }
    
    private func finishLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.onLoadingStateChanged?(false)
            
            if self.items.isEmpty {
                self.onEmptyResult?()
            } else {
                self.onDataUpdated?()
            }
        }
    }
    
    func fetchNext() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        onLoadingStateChanged?(true)
        
        let target = NetworkAPI.getPokemonCardList(param: currentQuery)
        let future = NetworkFuture<Data>()
        
        future.request(target: target)
            .done { [weak self] data in
                
                guard let self = self else { return }
                
                let decoder = JSONDecoder()
                let result = try decoder.decode([PokemonCardListResponse].self, from: data)
                
                guard !result.isEmpty else {
                    self.hasMorePages = false
                    self.finishLoading()
                    return
                }
                
                self.items.append(contentsOf: result)
                self.hasMorePages = result.count == self.currentQuery.paginationItemsPerPage
                self.currentQuery.paginationPage += 1
                self.finishLoading()
            }
            .catch { [weak self] error in
                guard let self = self else { return }
                
                self.hasMorePages = false
                self.finishLoading()
                self.onShowAlert?(error as? NetworkError ?? NetworkError())
            }
    }
}
