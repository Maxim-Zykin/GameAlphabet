//
//  SettingsTableViewController.swift
//  GameAlphabet
//
//  Created by Максим Зыкин on 26.11.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var switchTimer: UISwitch!
    @IBOutlet weak var timeGameLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }
    
    @IBAction func changedTimerState(_ sender: UISwitch) {
        Settings.shared.crrentSettings.timerState = sender.isOn
    }
    
    //загрузка настроек (обновления лейбла и switch)

    func loadSettings() {
        timeGameLable.text = "\(Settings.shared.crrentSettings.timeForGame) sec"
        switchTimer.isOn = Settings.shared.crrentSettings.timerState
    }
    
    @IBAction func resetSettings(_ sender: Any) {
        Settings.shared.ressetSennings()
        loadSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectTimeVC":
            if let vc = segue.destination as? SelectTimeViewController {
                vc.data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
            }
        default: break
        }
    }
}
