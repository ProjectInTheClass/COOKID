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
        dateFormatter.dateFormat = "yyyy년 M월 dd일"
        return dateFormatter
    }()
    
    var placeHolder: String
    @Binding var date: Date?
    
    
    func makeUIView(context: Context) -> UITextField {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
        }
        
        datePicker.maximumDate = Date()
        
        
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)
        
        textField.placeholder = placeHolder
        textField.inputView = datePicker
        
        self.helper.dateDidChanged = { self.date = datePicker.date }
        self.helper.doneButtonAction = {
            if date == nil {
                date = datePicker.date
            }
            textField.resignFirstResponder()
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self.helper,
                                         action: #selector(helper.donButtonTapped))
        toolbar.setItems([space, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        return self.textField
    }
    
    
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = self.date {
            uiView.text = self.dateFormatter.string(from: selectedDate)
            uiView.textColor = .darkGray
        }
    }
    
    func makeCoordinator() -> DatePickerTextField.Coordinator {
        Coordinator(textField: self)
    }
    
    
    final class Helper {
        
        var dateDidChanged: (() -> Void)?
        var doneButtonAction: (() -> Void)?
        
        @objc func dateValueChanged() {
            self.dateDidChanged?()
        }
        
        @objc func donButtonTapped() {
            self.doneButtonAction?()
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
