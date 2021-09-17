//
//  ContentView.swift
//  TicTacToe
//
//  Created by Shant Hovagimian on 9/15/21.
//

import SwiftUI


struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State private var moves: [Move?]  = Array(repeating: nil, count: 9)//Move will either be filled or nil based on if the person has made a move yet or not
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        GeometryReader { geometry in
            Text("Tic Tac Toe")
                .frame(width: geometry.size.width, height: 100, alignment: .center)
                
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) {i in
                        ZStack{
                            Circle()
                                .foregroundColor(.blue).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 25,
                                       height: geometry.size.width/3 - 25)
                            
                            Image(systemName: moves[i]? .indicator ?? "")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) {return} //Check to see if square is occupied and stopping if space is occupied
                            moves[i] = Move(player: .human, boardIndex: i)
                            
                            //Check for win condition or draw
                            if checkWinCondition(for: .human, in: moves) {
                                alertItem = AlertContext.humanWin
                                return
                            }
                            if checkForDraw(in: moves) {
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            isGameBoardDisabled = true

                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerPosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                           
                        }
                    }
                    
                }
                Spacer()
            }
            .padding()
            .disabled(isGameBoardDisabled)
            .alert(item: $alertItem) { alertItem in //Triggers whenever @State variable alertItem changes and resets game
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {resetGame()}
                ))
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    // Easy Mode: Determining if a position on the board is empty and filling it by the computer
    func determineComputerPosition(in moves: [Move?]) -> Int {
        
        let winPatterns: Set<Set<Int>> = [[0,1,2],
                                          [3,4,5],
                                          [6,7,8],
                                          [0,3,6],
                                          [1,4,7],
                                          [2,5,8],
                                          [0,4,8],
                                          [2,4,6]]
        //If AI can win, then win
        let computerMoves = moves.compactMap {  $0 }.filter {$0.player == .computer}
        let computerPositions = Set(computerMoves.map {$0.boardIndex})
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isAvailable = isSquareOccupied(in: moves, forIndex: computerPositions.first!)
                if isAvailable {return winPositions.first!}
                
            }
        }
        
        //If can't win, then block
        let humanMoves = moves.compactMap {  $0 }.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvailable = isSquareOccupied(in: moves, forIndex: humanPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        
        //Take middle if available
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        //If cant win take random square
        var movePosition = Int.random(in: 0..<9) //Selecting a random position on the board.
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)//Using recursion to call back function until an empty spot is found
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2],
                                          [3,4,5],
                                          [6,7,8],
                                          [0,3,6],
                                          [1,4,7],
                                          [2,5,8],
                                          [0,4,8],
                                          [2,4,6]]
        let playerMoves = moves.compactMap {  $0 }.filter {$0.player == player} //Returns the move without nils
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {return true} //Checks if playerPositions match any of winPatterns to see if player won
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle" //If human place x, else place circle
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
