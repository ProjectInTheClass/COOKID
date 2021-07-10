//
//  InputShoppingListViewController.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/10.
//

import UIKit
import SwiftUI

class InputShoppingListViewController: UIHostingController<InputShoppingListView> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: InputShoppingListView())
    }

}
