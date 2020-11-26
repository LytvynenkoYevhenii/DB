//
//  FilterTVController.swift
//  Cocktail DB
//
//  Created by Maryna Bereza on 11/24/20.
//  Copyright © 2020 Bereza Maryna. All rights reserved.
//

import UIKit


protocol FiltersListDelegate {
    func filtersListTableViewController(tvc: UIViewController, checkmarksDidChanged checkedIndexList: Set<Int>)
}

class FilterViewController:  UIViewController {

    var filtersListDelegate: FiltersListDelegate?
    var totalFilterDrinksList = [String]()
    var indexChecked: Set<Int> = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func applyButtton(_ sender: UIButton) {
        
        self.filtersListDelegate?.filtersListTableViewController(tvc: self, checkmarksDidChanged: self.indexChecked)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! FilterCell
        
        if cell.checkerImageView.isHidden {
            cell.showChecker(true)
            self.indexChecked.insert(indexPath.row)
        } else {
            cell.showChecker(false)
            self.indexChecked.remove(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalFilterDrinksList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let totalFilter = self.totalFilterDrinksList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        
        for index in self.indexChecked {
            
            if index == indexPath.row {
                
                cell.showChecker(true)
                break
            }
            else {
                cell.showChecker(false)
            }
        }
        cell.filterCellLabel.text = totalFilter
        cell.checkerImageView.image = UIImage(named: "checker")
        
        return cell
    }
}
