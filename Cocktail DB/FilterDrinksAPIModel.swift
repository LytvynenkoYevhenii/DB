//
//  FilterDrinksAPIModel.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/24/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit

struct FilterDrinksAPIModel:Decodable {
    let drinks: [DrinkCategoryAPIModel]
}

struct DrinkCategoryAPIModel {
    let sectionName: String
    
    enum CodingKeys: String, CodingKey {
        case sectionName = "strCategory"
    }
}

extension DrinkCategoryAPIModel: Decodable {
    
    init(from decoder: Decoder) throws  {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        sectionName = try values.decode(String.self, forKey: .sectionName)
    }
}
