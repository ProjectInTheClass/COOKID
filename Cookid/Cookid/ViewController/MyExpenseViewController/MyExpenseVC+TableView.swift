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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.section].name == "마트털이" {
            if let vc = UIStoryboard(name: "InputDataShoppingViewController", bundle: nil).instantiateViewController(identifier: "InputDataShoppingViewController") as? InputDataShoppingViewController {
                let price = selectedShopping[indexPath.row].totalPrice
                let date = selectedShopping[indexPath.row].date.dateToString()
                vc.dateTextField.text = date
                vc.priceTextField.text = String(price)
                vc.rightBtn.setTitle("수정", for: .normal)
                self.present(vc, animated: true, completion: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.present(vc, animated: true, completion: nil)
            }
        }
    }
}


