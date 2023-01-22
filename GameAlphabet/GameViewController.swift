//
//  GameViewController.swift
//  GameAlphabet
//
//  Created by Максим Зыкин on 19.11.2022.
//

import UIKit

class GameViewController: UIViewController {


    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var statysLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    
    lazy var game = Game(countItems: Buttons.count) { [weak self] (status, time) in
        guard let self = self else { return }
        
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    //при выходе с игры отключаем таймер
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }

    @IBAction func pressButton(_ sender: UIButton) {
        //поиск нажатой кнопки
        guard let buttonIndex = Buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex)
        //sender.isHidden = true
        updateUI()
    }
    
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    // проходимся по массиву Items  и присвоить всем Buttons нужные свойста
    private func setupScreen() {
        
        for index in game.items.indices{
            Buttons[index].setTitle(game.items[index].title, for: .normal)
            //Buttons[index].isHidden = false
            Buttons[index].alpha = 1
            Buttons[index].isEnabled = true
        }
        // обновлять nextDigit c новым значением
        nextDigit.text = game.nextItem?.title
    }
   
    //функция обновления экрана
    private func updateUI() {
        //проходимся по массиву
        for index in game.items.indices {
           // Buttons[index].isHidden = game.items[index].isFound
            Buttons[index].alpha = game.items[index].isFound ? 0 : 1
            Buttons[index].isEnabled = !game.items[index].isFound
           // анимация для несоответствующей кнопки
            if game.items[index].isError{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.Buttons[index].backgroundColor = .red
                } completion: { [weak self](_) in
                    self?.Buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }
            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statysLabel.text = "The game has begun"
            statysLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statysLabel.text = "You won!"
            statysLabel.textColor = .green
            newGameButton.isHidden = false
           if game.isNewRecord{
                showAlert()
           } else {
               showAlertActionSheet()
           }
        case .lose:
            statysLabel.text = "Game over"
            statysLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    // создание alerta
    private func showAlert() {
        let alert = UIAlertController(title: "Congratulations", message: "You set a new record!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showAlertActionSheet() {
        let alert = UIAlertController(title: "Your next step?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAtion = UIAlertAction(title: "Start a new game", style: .default) { [weak self](_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        let showRecord = UIAlertAction(title: "View Highscore", style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        let menuAction = UIAlertAction(title: "Go to menu", style: .default) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(newGameAtion)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)

        //доп настройки для iPad
        if let popover = alert.popoverPresentationController{
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        present(alert, animated: true)
    }
}
