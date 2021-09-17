//
//  Alerts.swift
//  TicTacToe
//
//  Created by Shant Hovagimian on 9/17/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You are so smart. You beat the AI"),
                                    buttonTitle: Text("Great Job!"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                                       message: Text("The AI was smarter than you"),
                                       buttonTitle: Text("Rematch!"))
    static let draw = AlertItem(title: Text("Draw!"),
                                message: Text("What a Match"),
                                buttonTitle: Text("Try Again!"))
}

