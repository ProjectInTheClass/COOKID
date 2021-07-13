//
//  MyExpenseVC+TableView.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/09.
//

import UIKit

extension MyExpenseViewController :  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].selected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier, for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell()}
        
        switch data[indexPath.section].name {
        case "집밥":
            cell.label.text = String(selectedDineInMeals[indexPath.row].price) + "원"
            cell.dateLabel.text = dateFormatter.string(from: selectedDineInMeals[indexPath.row].date)
            return cell
        case "외식":
            cell.label.text = String(selectedDineOutMeals[indexPath.row].price) + "원"
            cell.dateLabel.text = dateFormatter.string(from: selectedDineOutMeals[indexPath.row].date)
            return cell
        case "마트털이" :
            cell.label.text = String(selectedShopping[indexPath.row].totalPrice) + "원"
            cell.dateLabel.text = dateFormatter.string(from: selectedShopping[indexPath.row].date)
            return cell
        default:
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var count : Int = 0
        for element in data {
            if !element.selected.isEmpty {
                count += 1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !data[section].selected.isEmpty {
            return data[section].name
        } else {
            return nil
        }
    }
    
}


