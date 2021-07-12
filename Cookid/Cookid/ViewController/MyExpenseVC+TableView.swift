//
//  MyExpenseVC+TableView.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/09.
//

import UIKit


extension MyExpenseViewController :  UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        if section == 0 {
            return selectedDineInMeals?.count ?? 0
        } else if section == 1 {
            return selectedDineOutMeals?.count ?? 0
        } else {
            return selectedShopping?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier, for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell() }
        
        if let selectedDineInMeals = selectedDineInMeals {
            if indexPath.section == 0 {
                cell.label.text = String(selectedDineInMeals[indexPath.row].price) + "원"
                cell.dateLabel.text = dateFormatter.string(from: selectedDineInMeals[indexPath.row].date)
            }
        }

        if let selectedDineOutMeals = selectedDineOutMeals {
            if indexPath.section == 1 {
                cell.label.text = String(selectedDineOutMeals[indexPath.row].price) + "원"
                cell.dateLabel.text = dateFormatter.string(from: selectedDineOutMeals[indexPath.row].date)

            }
        }
        
        if let selectedShopping = selectedShopping {
            if indexPath.section == 2 {
                cell.label.text = String(selectedShopping[indexPath.row].totalPrice) + "원"
                cell.dateLabel.text = dateFormatter.string(from: selectedShopping[indexPath.row].date)
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return sections[0]
        } else if section == 1 {
            return sections[1]
        } else if section == 2 {
            return sections[2]
        } else {
            return nil
        }
    }
    
}


