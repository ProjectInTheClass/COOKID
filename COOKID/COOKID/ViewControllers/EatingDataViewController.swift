//
//  EatingDataViewController.swift
//  COOKID
//
//  Created by Sh Hong on 2021/04/28.
//

import UIKit

class EatingDataViewController: UIViewController {

    
    @IBOutlet var dayButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
}
