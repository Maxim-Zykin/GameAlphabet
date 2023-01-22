//
//  Settings.swift
//  GameAlphabet
//
//  Created by Максим Зыкин on 26.11.2022.
//

import Foundation


struct SettingsGame: Codable {
    var timerState: Bool
    var timeForGame: Int
}


class Settings {
    static var shared = Settings()
    
    //сохранение SettingsGame в хранилище
  private let deautSettings = SettingsGame(timerState: true, timeForGame: 30)
    
    var crrentSettings: SettingsGame{
        get {
            if let data = UserDefaults.standard.object(forKey: "settingsGame") as? Data{
                //получение текущих настроек
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            } else {
                if let data = try? PropertyListEncoder().encode(deautSettings) {
                    UserDefaults.standard.setValue(data, forKey: "settingsGame")
                }
                return deautSettings
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: "settingsGame")
            }
        }
    }
    
    func ressetSennings() {
        crrentSettings = deautSettings
    }
}
