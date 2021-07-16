//
//  MyExpenseVC+TableView.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/09.
//

import UIKit

extension MyExpenseViewController :  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch data[section].name {
        case "외식":
            return selectedDineOutMeals.count
        case "집밥":
            return selectedDineInMeals.count
        case "마트털이" :
            return selectedShopping.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier, for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell()}
        
        switch data[indexPath.section].name {
        case "외식":
            cell.label.text = String(selectedDineOutMeals[indexPath.row].price) + "원"
            cell.dateLabel.text = dateFormatter.string(from: selectedDineOutMeals[indexPath.row].date)
            return cell
        case "집밥":
            cell.label.text = String(selectedDineInMeals[indexPath.row].price) + "원"
            cell.dateLabel.text = dateFormatter.string(from: selectedDineInMeals[indexPath.row].date)
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
        let count = data.count
        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return data[section].name
    }
    
    //MARK: - Show UpdateShoppingData didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        print("didselected  indexPath \(indexPath)")
        print("selected Shopping count : \(selectedShopping.count)")
        if data[indexPath.section].name == "마트털이" {
            let vc = InputDataShoppingViewController(service: viewModel.shoppingService)
            let price = self.selectedShopping[indexPath.row].totalPrice
            let date = self.selectedShopping[indexPath.row].date.dateToString()
            vc.dateTextField.text = date
            vc.priceTextField.text = String(price)
            vc.currentPrice = String(price)
            vc.currentDate = date
            vc.selectBtn(btnState: .updateBtnOn)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else {
            tableView.cellForRow(at: indexPath)?.selectionStyle = .default
        }
        
    }
    
    //MARK: - Delete ShoppingData in TableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if data[indexPath.section].name == "마트털이" {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.shoppingService.delete(shopping: selectedShopping[indexPath.row])
            selectedShopping.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("selectedShopping.count\(selectedShopping.count)")
            print("indexPath: \(indexPath) indexPathsection: \(indexPath.section) indexPathrow: \(indexPath.row)")
        }
    }
    
}


