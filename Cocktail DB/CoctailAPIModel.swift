//
//  CoctailModel.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/24/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit

struct DrinksCategotyAPIModel:Decodable {
    let drinks: [CoctailAPIModel]
}

struct CoctailAPIModel {
    let coctailName: String
    let coctailImage: String
    
    enum CodingKeys: String, CodingKey {
        case coctailName = "strDrink"
        case coctailImage = "strDrinkThumb"
    }
}


extension CoctailAPIModel: Decodable {
    
    init(from decoder: Decoder) throws  {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        coctailName = try values.decode(String.self, forKey: .coctailName)
        
        coctailImage = try values.decode(String.self, forKey: .coctailImage)
    }
}
