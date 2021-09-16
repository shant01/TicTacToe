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
    @State private var isHumansTurn = true
    
    var body: some View {
        GeometryReader { geometry in
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
                            
                            moves[i] = Move(player: isHumansTurn ? .human : .computer, boardIndex: i)
                            isHumansTurn.toggle()
                        }
                    }
                    
                }
                Spacer()
            }
            
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
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
        ContentView()
    }
}
