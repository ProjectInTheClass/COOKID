//
//  DatePickerTextField.swift
//  TestHostingVC
//
//  Created by 임현지 on 2021/07/10.
//

import Foundation
import SwiftUI

struct DatePickerTextField: UIViewRepresentable {
    
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    private let dateFormatter: DateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter
    }()
    
    var placeHolder: String
    
    @Binding var date: Date?
    
    func makeUIView(context: Context) -> UITextField {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)
        
        textField.placeholder = placeHolder
        textField.inputView = datePicker
        helper.dateDidChanged =
            { date = datePicker.date
            datePicker.resignFirstResponder()
        }
        
        return self.textField
    }
    
    
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = self.date {
            uiView.text = self.dateFormatter.string(from: selectedDate)
        }
    }
    
    func makeCoordinator() -> DatePickerTextField.Coordinator {
        Coordinator(textField: self)
    }
    
    
    final class Helper {
        
        var dateDidChanged: (() -> Void)?
        
        @objc func dateValueChanged() {
            self.dateDidChanged?()
        }
    }
    
    
    final class Coordinator: NSObject,  UITextFieldDelegate {
        private let parent: DatePickerTextField
        
        init(textField: DatePickerTextField) {
            self.parent = textField
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.textField.resignFirstResponder()
            parent.datePicker.resignFirstResponder()
        }
    }
}
