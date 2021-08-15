//
//  MyExpenseVC+TableView.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/09.
//

import UIKit

/*
extension MyExpenseViewController :  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier, for: indexPath) as? ExpenseTableViewCell else { return UITableViewCell()}
//
//        switch "\(result.keys)" {
//        case "외식":
//            cell.label.text = intToString(result.values[0]))
//            cell.dateLabel.text = dateFormatter.string(from: selectedDineOutMeals[indexPath.row].date)
//            return cell
//        case "집밥":
//            cell.label.text = intToString(selectedDineInMeals[indexPath.row].price)
//            cell.dateLabel.text = dateFormatter.string(from: selectedDineInMeals[indexPath.row].date)
//            return cell
//        case "마트털이" :
//            cell.label.text = intToString(selectedShopping[indexPath.row].totalPrice)
//            cell.dateLabel.text = dateFormatter.string(from: selectedShopping[indexPath.row].date)
//            return cell
//        default:
//            return cell
//        }
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        let count = data.count
//        return count
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        return data[section].name
        return ""
    }
    
    //MARK: - Show UpdateShoppingData didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: false)
//        if data[indexPath.section].name == "마트털이" {
//            let vc = InputDataShoppingViewController(service: viewModel.shoppingService)
//            let price = self.selectedShopping[indexPath.row].totalPrice
//            let date = self.selectedShopping[indexPath.row].date.dateToString()
//            vc.dateTextField.text = date
//            vc.priceTextField.text = String(price)
//            vc.currentPrice = String(price)
//            vc.currentDate = date
//            vc.selectBtn(btnState: .updateBtnOn)
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true, completion: nil)
//        } else {
//            tableView.cellForRow(at: indexPath)?.selectionStyle = .default
//        }
        
    }
    
    //MARK: - Delete ShoppingData in TableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if data[indexPath.section].name == "마트털이" {
//            return true
//        } else {
//            return false
//        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            let deleteShopping = selectedShopping[indexPath.row]
//            if let index = shopping.firstIndex(where: { $0.id == deleteShopping.id }) {
//                shopping.remove(at: index)
//            }
//
//            self.viewModel.shoppingService.delete(shopping: selectedShopping[indexPath.row])
//            guard let selectedDate = calendar.selectedDate else { return }
//            viewModel.updateItems(date: [selectedDate])
//
//        }
    }
    
}

*/
