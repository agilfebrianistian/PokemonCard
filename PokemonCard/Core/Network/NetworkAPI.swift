//
//  NetworkAPI.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import UIKit
import Moya
import Foundation
import Alamofire

enum NetworkAPI {
    case getPokemonCardList(param: PokemonCardListParameter)
    case getPokemonCardDetail(cardId: String)
}

// MARK: - TargetType Protocol Implementation
extension NetworkAPI: NetworkTarget {
    var baseURL: URL {
        return URL(string: NetworkConstant.APIConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPokemonCardList:
            return "cards"
        case .getPokemonCardDetail(cardId: let cardId):
            return "cards/\(cardId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPokemonCardList(let param):
            return .requestParameters(parameters: param.asDictionary ?? [:],
                                      encoding: URLEncoding.default)
        default :
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "".utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Accept":"application/json"]
    }
    
}
