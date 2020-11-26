//
//  DrinksViewController.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/26/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit
import SDWebImage

class DrinksViewController: UIViewController , FiltersListDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vcNameLabel: UILabel!

    var requestInProgress = true
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var currentCategoryNameForRequest = ""
    var categories = [String]()
    var selectedDrinksIndices: Set<Int> = []
    var sortedSelectedDrinksIndices = [Int]()
    
    var indexCategoryForFetchNew = 0
    var drinksCategories = [[CoctailModel]]()
    var drinksCategoryList = [CoctailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CoctailCell", bundle: nil), forCellReuseIdentifier: "CoctailCell")
        tableView.register(UINib(nibName: "HeaderSectionCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderSectionCell")
        
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        // MARK: - Fetch Filters
        CoctailAPIServerManager.fetchRequestFilterList { [weak self](list) in
            
            guard let weakSelf = self else {
                return
            }
            
            for filterName in list.drinks {
                weakSelf.categories.append(filterName.sectionName)
            }
            
            for (index, _) in weakSelf.categories.enumerated() {
                weakSelf.selectedDrinksIndices.insert(index)
            }
            weakSelf.sortedSelectedDrinksIndices = weakSelf.selectedDrinksIndices.sorted()
            
            let firstSectionNameForRequest = weakSelf.categories.first
            
            guard let firstSectionListName = firstSectionNameForRequest else {
                return
            }
            
            weakSelf.currentCategoryNameForRequest = firstSectionListName
            
            // MARK: - Fetch Coctails from Category
            weakSelf.getNewCategoryCoctails(forCategoryName: weakSelf.currentCategoryNameForRequest)
        }
    }
    // MARK: - FiltersListDelegate Protocol
    
    func filtersListTableViewController(tvc: UIViewController, checkmarksDidChanged checkedIndexList: Set<Int>) {
        
        indexCategoryForFetchNew = 0
        drinksCategoryList.removeAll()
        drinksCategories.removeAll()
        self.selectedDrinksIndices = checkedIndexList
        
        self.sortedSelectedDrinksIndices = self.selectedDrinksIndices.sorted()
        
        self.activityIndicator.startAnimating()
        
        if !self.selectedDrinksIndices.isEmpty {
            
            let categoryName = self.categories[self.sortedSelectedDrinksIndices[self.indexCategoryForFetchNew]]
            self.getNewCategoryCoctails(forCategoryName: categoryName)

        }
    }
    
    func getNewCategoryCoctails(forCategoryName name: String) {
        requestInProgress = true
        
        CoctailAPIServerManager.fetchRequestCoctailsListWithName(name: name) { [weak self](coctailModels) in
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.currentCategoryNameForRequest = weakSelf.categories[weakSelf.indexCategoryForFetchNew]
            weakSelf.drinksCategoryList.removeAll()
            for coctail in coctailModels.drinks {
                
                let coctailModel = CoctailModel(coctailName: coctail.coctailName, coctailImage: coctail.coctailImage)
                weakSelf.drinksCategoryList.append(coctailModel)
            }
            
            weakSelf.drinksCategories.append(weakSelf.drinksCategoryList)
            
            weakSelf.tableView.reloadData()
  
            weakSelf.requestInProgress = false
            
            weakSelf.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        
        let filterTVC = self.storyboard?.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
        filterTVC.filtersListDelegate = self
        filterTVC.totalFilterDrinksList = self.categories
        filterTVC.indexChecked = self.selectedDrinksIndices
        
        self.navigationController?.pushViewController(filterTVC, animated: true)
    }
    
    
    
}


extension DrinksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderSectionCell") as! HeaderSectionCell
        
        let index = self.sortedSelectedDrinksIndices[section]
        headerCell.drinksNameLabel.text = self.categories[index]

        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canLoadMore() {
            return
        }
        
        let topDistance = scrollView.contentOffset.y
        let middleDistance = scrollView.frame.height
        let bottomDistance = scrollView.contentSize.height - topDistance - middleDistance
        
        if bottomDistance < 50 {
            
            indexCategoryForFetchNew += 1
            let indexNextCategory = sortedSelectedDrinksIndices[indexCategoryForFetchNew]
            let categoryName = categories[indexNextCategory]
            getNewCategoryCoctails(forCategoryName: categoryName)
        }
    }
    
    func canLoadMore() -> Bool {
        var result = true
        
        if requestInProgress || indexCategoryForFetchNew >= sortedSelectedDrinksIndices.count - 1 {
            
            result = false
        }
        return result
    }
    
}

extension DrinksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return drinksCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.drinksCategories.isEmpty {
            let category = self.drinksCategories[section]
            return category.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = self.drinksCategories[indexPath.section]
        let coctail = category[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoctailCell", for: indexPath) as! CoctailCell
        
        cell.coctailNameLabel.text = coctail.coctailName
        
        cell.coctailImage.sd_setImage(with: URL(string: coctail.coctailImage), completed: nil)
        
        return cell
    }
}

