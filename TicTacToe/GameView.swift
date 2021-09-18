//
//  GameView.swift
//  TicTacToe
//
//  Created by Shant Hovagimian on 9/15/21.
//

import SwiftUI


struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    
    
    var body: some View {
        GeometryReader { geometry in
            Text("Tic Tac Toe")
                .frame(width: geometry.size.width, height: 100, alignment: .center)
                .font(.custom("Copperplate", size: 55).weight(.bold))
                .padding(.top, 60)
                
                
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) {i in
                        ZStack{
                            Circle()
                                .foregroundColor(.blue).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 25,
                                       height: geometry.size.width/3 - 25)
                            
                            Image(systemName: viewModel.moves[i]? .indicator ?? "")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                    
                }
                Spacer()
            }
            .padding()
            .disabled(viewModel.isGameBoardDisabled)
            .alert(item: $viewModel.alertItem) { alertItem in //Triggers whenever @State variable alertItem changes and resets game
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame()}
                ))
            }
        }
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
            GameView()
            GameView()
        }
    }
}
