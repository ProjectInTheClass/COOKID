//
//  SelectCalendarViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa
import NSObject_Rx

class SelectCalendarViewController: UIViewController, StoryboardBased {
    
    var completionHandler: ((Date)->Void)?
    
    @IBOutlet weak var updateCalendar: FSCalendar!
    @IBOutlet weak var dimmingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimmingButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        initializeForUpdateCalendar()
    }
    
    private func initializeForUpdateCalendar() {
        //utility
        updateCalendar.select(Date())
        updateCalendar.delegate = self
        updateCalendar.dataSource = self
        updateCalendar.scope = .month
        updateCalendar.backgroundColor = .white
        updateCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // header
        updateCalendar.headerHeight = 70
        updateCalendar.appearance.headerTitleColor = UIColor.black
        updateCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        updateCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        updateCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24, weight: .light)
        
        // week
        updateCalendar.appearance.weekdayTextColor = UIColor.darkGray
        updateCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .light)
        updateCalendar.locale = Locale(identifier: "ko_KR")
        
        //body
        updateCalendar.layer.masksToBounds = true
        updateCalendar.layer.cornerRadius = 20
        updateCalendar.appearance.titleTodayColor = .red
        updateCalendar.appearance.todayColor = .clear
        updateCalendar.appearance.todaySelectionColor = .darkGray
        updateCalendar.appearance.selectionColor = .darkGray
        updateCalendar.appearance.eventDefaultColor = .lightGray
    }
    
    
}

extension SelectCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if let completionHandler = completionHandler {
            completionHandler(date)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
