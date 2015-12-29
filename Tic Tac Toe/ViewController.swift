//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by msalamon on 12/18/15.
//  Copyright © 2015 msalamon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

var singlePlayer = true

var activePlayer = 2 //1 = O, 2 = X

var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]

let winningCombos = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [1, 4, 7], [0, 3, 6], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

var gameActive = true
    
var circleDone = true


@IBOutlet var PlayerModeLabel: UILabel!

@IBAction func PlayerButton(sender: AnyObject) {

    if !singlePlayer {
        PlayerModeLabel.text = "1 Player Mode - Player Vs. Computer"
        animatePlayerModeLabelOn()
    }

    singlePlayer = true
}

@IBAction func Playerbutton(sender: AnyObject) {

    if singlePlayer {
        PlayerModeLabel.text = " 2 Player Mode - Player Vs. Player"
        animatePlayerModeLabelOn()
    }

    singlePlayer = false
}

@IBOutlet var playAgainButton: UIButton!

@IBAction func playAgain(sender: AnyObject) {

activePlayer = 2 //1 = O, 2 = X
    
circleDone = true

gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]

gameActive = true

gameOverLabel.hidden = true

gameOverLabel.center.x -= view.bounds.width

playAgainButton.hidden = true

playAgainButton.center.x += view.bounds.width

var buttonToClear : UIButton

    for var i = 0; i < 9; i++ {
        
        buttonToClear = view.viewWithTag(i) as! UIButton

        buttonToClear.setImage(nil, forState: .Normal)
       
    }

}


@IBOutlet var button: UIButton!


@IBOutlet var gameOverLabel: UILabel!


@IBAction func buttonPressed(sender: AnyObject) {

let seconds = 1.5
let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

    if singlePlayer == true {
        if (gameState[sender.tag] == 0 && gameActive == true && circleDone == true) {

            sender.setImage(UIImage(named: "x.png"), forState: .Normal)

            gameState[sender.tag] = 2

            activePlayer = 1
            
            circleDone = false

            // var buttonToCircle : UIButton

            var openSpots = [Int]()

                for var i = 0; i < 9; i++ {

                    if gameState[i] == 0 {

                        openSpots.append(i)

                    } //if
                } //for

        if (openSpots.count > 0 && activePlayer == 1 && gameActive == true) {

            for combo in winningCombos {
                
                if gameState[combo[0]] != 0 {

                    if (gameState[combo[0]] == 1 && gameState[combo[0]] == gameState[combo[1]]) {

                        if gameState[combo[2]] == 0 {
                        
                            drawCircle(combo[2])

                            break
                        }
                    }
                }

            if gameState[combo[2]] != 0 {

                if (gameState[combo[2]] == 1 && gameState[combo[2]] == gameState[combo[1]]) {

                    if gameState[combo[0]] == 0 {

                        drawCircle(combo[0])

                        break
                    }
                }
            }

            if gameState[combo[0]] != 0 {

                if (gameState[combo[0]] == 1 && gameState[combo[0]] == gameState[combo[2]]) {

                    if gameState[combo[1]] == 0 {

                        drawCircle(combo[1])

                        break

                    }
                }
            }

        } // for Circle WIN combos

    }// if


//now check for blocks
    if (openSpots.count > 0 && activePlayer == 1 && gameActive == true) {
        for combo in winningCombos {

            if gameState[combo[0]] != 0 {

                if (gameState[combo[0]] == gameState[combo[1]]) {

                    if gameState[combo[2]] == 0 {

                        checkWin()
                        if gameActive == true {
                            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                self.drawCircle(combo[2])
                                self.circleDone = true
                            })
                        }
                        
                        activePlayer = 2
                        gameState[combo[2]] = 1
                        break
                    }
                }
            }

            if gameState[combo[2]] != 0 {

                if (gameState[combo[2]] == gameState[combo[1]]) {

                    if gameState[combo[0]] == 0 {
                        
                        checkWin()
                        if gameActive == true {
                            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                self.drawCircle(combo[0])
                                self.circleDone = true
                            })
                        }

                        activePlayer = 2
                        gameState[combo[0]] = 1
                        break
                    }
                }
            }


            if gameState[combo[0]] != 0 {

                if (gameState[combo[0]] == gameState[combo[2]]) {

                    if gameState[combo[1]] == 0 {

                        checkWin()
                            if gameActive == true {
                                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                                    self.drawCircle(combo[1])
                                    self.circleDone = true
                                })
                            }

                        activePlayer = 2
                        gameState[combo[1]] = 1
                        break

                    }
                }
            }

        } // for combos


    } //if openSpots.count > 0


    if (openSpots.count > 0 && activePlayer == 1) {
        

        let randomIndex = Int(arc4random_uniform(UInt32(openSpots.count)))

        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {

                // here code perfomed with delay
            if self.gameActive == true {
                self.drawCircle(openSpots[randomIndex])
                self.circleDone = true
            }
            })

        gameState[openSpots[randomIndex]] = 1
        activePlayer = 2


        } //if openSpots.count > 0

            checkWin()

    }
    
}// singlePlayer

else {



//2 Player Mode


    if (gameState[sender.tag] == 0 && gameActive == true) {

        gameState[sender.tag] = activePlayer

        if activePlayer == 1 {


            sender.setImage(UIImage(named: "circle.png"), forState: .Normal)

            activePlayer = 2


        }
        else {


            sender.setImage(UIImage(named: "x.png"), forState: .Normal)

            activePlayer = 1

        }

        checkWin()


        }

    } //else not single player
}


func animatePlayerModeLabelOn() {

    PlayerModeLabel.hidden = false
    
    UIView.animateWithDuration(0.5, animations: {

        self.PlayerModeLabel.center.x += self.view.bounds.width

    })
}

func drawCircle(place : Int) {

    let buttonToCircle = view.viewWithTag(place) as! UIButton

    buttonToCircle.setImage(UIImage(named: "circle.png"), forState: .Normal)

    gameState[place] = 1

    activePlayer = 2

}

func checkWin() {

    for combo in winningCombos {

        if (gameState[combo[0]] != 0 && gameState[combo[0]] == gameState[combo[1]] && gameState[combo[1]] == gameState[combo[2]]) {

            gameActive = false

            if gameState[combo[0]] == 1 {

                gameOverLabel.text = "O WINS!"

            }
            else {
                gameOverLabel.text = "X WINS!"

            }

            endGame()

            }
        }

    if gameActive ==  true {

        gameActive = false

        for buttonState in gameState {

            if buttonState == 0 {

                gameActive = true
            }

        }

        if gameActive == false {

            gameOverLabel.text = "It's a Draw!"

            endGame()
        }
    }
}

func endGame() {
    
    gameActive = false

    gameOverLabel.hidden = false
    
    playAgainButton.hidden = false

    UIView.animateWithDuration(0.5, animations: {

        self.gameOverLabel.center.x += self.view.bounds.width

    })

    UIView.animateWithDuration(0.5, delay: 0.9, options: [], animations: {

        self.playAgainButton.center.x -= self.view.bounds.width

        }, completion: nil)

}


override func viewDidLoad() {
    
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    circleDone = true
    
    gameOverLabel.hidden = true

    gameOverLabel.center.x -= view.bounds.width

    playAgainButton.hidden = true

    playAgainButton.center.x += view.bounds.width

    PlayerModeLabel.text = "1 Player Mode - Player Vs. Computer"

}

override func didReceiveMemoryWarning() {

    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


} // end Class

