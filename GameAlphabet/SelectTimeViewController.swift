//
//  SelectTimeViewController.swift
//  GameAlphabet
//
//  Created by Максим Зыкин on 26.11.2022.
//

import UIKit

class SelectTimeViewController: UIViewController {

    var data:[Int] = []
     
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()    
    }
}


extension SelectTimeViewController: UITableViewDataSource, UITableViewDelegate {

    //количество строк(секций)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //указываем что это за ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row])
        
        return cell
    }
    

    // выбор строки по indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //снять выделение
        tableView.deselectRow(at: indexPath, animated: true)
        //сохраняем настройки
        Settings.shared.crrentSettings.timeForGame = data[indexPath.row]
        //после выбора настроек возвращаемся на пред экран
        navigationController?.popViewController(animated: true)
    }

}
