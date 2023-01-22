//
//  Game.swift
//  GameAlphabet
//
//  Created by Максим Зыкин on 19.11.2022.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game {
    
    //отвечает за кнопки
    struct Item {
        var title: String
        var isFound: Bool = false
        var isError = false
    }
    
    
    private let date = Array(arrayLiteral: "A","B","C","D","E","F","G","H","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
    
    var items: [Item] = []
    //передаем количество кнопок
    private var countItems: Int
    
    // следующая буква, которую необходимо будет найти
    var nextItem: Item?
    
    var isNewRecord = false
    
    var status: StatusGame = .start {
        didSet {
            if status != .start {
                if status == .win{
                    let newRecord = timeForGame - secondsGame
                    let record = UserDefaults.standard.integer(forKey: "recordGame")
                    
                    if record == 0 || newRecord < record {
                        UserDefaults.standard.setValue(newRecord, forKey: "recordGame")
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }
    private var timeForGame: Int
    
    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
            updateTimer(status, secondsGame)
        }
    }
    
    private var timer: Timer?
    
    private var updateTimer:((StatusGame, Int) -> Void)
    
    init(countItems: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> Void) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.crrentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupSanes() 
    }
    
    
    private func setupSanes() {
        isNewRecord = false
        // перемешиваем массив
        var digits = date.shuffled()
        items.removeAll()
        //добавляем кнопки, не повторяющиеся
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        //создание nextIten рандомно
        nextItem = items.shuffled().first
        
        updateTimer(status, secondsGame)

        //запускаем таймер
        if Settings.shared.crrentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](_) in
                self?.secondsGame -= 1
            })
        }
    }

    func newGame() {
        status = .start
        self.secondsGame = self.timeForGame
        setupSanes()
    }
    
    func check(index: Int) {
        guard status == .start else { return } // если игра .start то кнопки нажимаются, иначе нет
        if items[index].title == nextItem?.title {
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            })
        } else {
            items[index].isError = true
        }
        if nextItem == nil {
            status = .win
        }
    }
    
  //функция останавливающая таймер
   func stopGame() {
      timer?.invalidate()
    }
}

    extension Int{
        // форматирование для таймера
    func secondsToString() -> String {
        let  minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
