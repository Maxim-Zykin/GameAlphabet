//
//  RecordViewController.swift
//  GameAlphabet
//
//  Created by Максим Зыкин on 04.12.2022.
//

import UIKit

class RecordViewController: UIViewController {

    
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let record = UserDefaults.standard.integer(forKey: "recordGame")
        if record != 0 {
            recordLabel.text = "Your record - \(record)"
        } else {
            recordLabel.text = "Record not set"
        }
    }

    @IBAction func clouseVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
