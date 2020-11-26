//
//  CoctailAPIServerManager.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/24/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit

class CoctailAPIServerManager {
    
    static func fetchRequestFilterList(completion: @escaping(_ list: FilterDrinksAPIModel) -> ()) {
        
        let filterListURL:URL = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list")!
        
        let task = URLSession.shared.dataTask(with: filterListURL) {(data, response, error) in
            
            guard let data = data else {
                
                return
            }
            
            if let error = error {
                print(error)
            } else {
                
                let filterDrinksModel = try! JSONDecoder().decode(FilterDrinksAPIModel.self, from: data)
                
                DispatchQueue.main.async {
                    
                    completion(filterDrinksModel)  
                }
            }
        }
        task.resume()
    }
    
    
    static func fetchRequestCoctailsListWithName(name: String, completion: @escaping(_ list: DrinksCategotyAPIModel) -> ()) {
        
        guard let nameQuery = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let drinksListURL:URL = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(nameQuery)") else {
            fatalError()
        }
        
        let task = URLSession.shared.dataTask(with: drinksListURL) {(data, response, error) in
            
            guard let data = data else {
                return
            }
            
            if let error = error {
                print(error)
                
            } else {
                
                let coctailModels = try! JSONDecoder().decode(DrinksCategotyAPIModel.self, from: data)
                
                DispatchQueue.main.async {
                    
                    completion(coctailModels)
                }
            }
        }
        task.resume()
    }
}
