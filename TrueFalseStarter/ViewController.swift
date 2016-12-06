//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 5
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var startSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 1
    var incorrectSound: SystemSoundID = 2
    var goodGame: SystemSoundID = 3
    var badGame: SystemSoundID = 4
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerResponse: UILabel!
    @IBOutlet weak var ButtonA: UIButton!
    @IBOutlet weak var ButtonB: UIButton!
    @IBOutlet weak var ButtonC: UIButton!
    @IBOutlet weak var ButtonD: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var home: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if (backgroundID == 1) {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "starsbackground.jpg")!)
        } else if (backgroundID == 2) {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "beachbackground.jpg")!)
        } else if (backgroundID == 3) {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "landscapebackground.jpg")!)
        }
        loadGameStartSound()
        loadAnswerCorrectSound()
        loadAnswerIncorrectSound()
        loadGoodGameSound()
        loadBadGameSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func displayProblem() {
//        let buttonAssoc = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
//        let randomInt = GKRandomSource.sharedRandom().nextInt(upperBound: 200)
//        let firstTerm = GKRandomSource.sharedRandom().nextInt(upperBound: 100)
//        let secondTerm = GKRandomSource.sharedRandom().nextInt(upperBound: 100)
//        let sum = firstTerm + secondTerm
//        var buttonOptions: [Int:UIButton] = [0: ButtonA, 1: ButtonB, 2: ButtonC, 3: ButtonD]
//        questionField.text = "\(firstTerm) + \(secondTerm)"
//        ButtonA.isHidden = false
//        ButtonB.isHidden = false
//        ButtonC.isHidden = false
//        ButtonD.isHidden = false
//        if (!usedButtons.contains(buttonAssoc)) {
//        buttonOptions[buttonAssoc]?.setTitle(String(randomInt), for: UIControlState.normal)
//            displayProblem()
//            usedButtons.append(buttonAssoc)
//        } else {
//            if usedButtons.count < 3 {
//                displayProblem()
//            }
//        }
//    }
    
    func displayQuestion() {
        
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaModel.count)
        let questionObj = triviaModel[indexOfSelectedQuestion]
        setStartBackgroundColor()
        if (!askedQuestions.contains(indexOfSelectedQuestion)) {
            questionField.text = questionObj.question
            answerResponse.isHidden = true
            playAgainButton.isHidden = true
            switch questionObj.type {
            case QuestionType.truefalse:
                ButtonA.isHidden = false
                ButtonA.setTitle(questionObj.options[1], for: UIControlState.normal)
                ButtonB.isHidden = false
                ButtonB.setTitle(questionObj.options[0], for: UIControlState.normal)
                ButtonC.isHidden = true
                ButtonD.isHidden = true
            case QuestionType.fourOption:
                ButtonA.isHidden = false
                ButtonA.setTitle(questionObj.options[0], for: UIControlState.normal)
                ButtonB.isHidden = false
                ButtonB.setTitle(questionObj.options[1], for: UIControlState.normal)
                ButtonC.isHidden = false
                ButtonC.setTitle(questionObj.options[2], for: UIControlState.normal)
                ButtonD.isHidden = false
                ButtonD.setTitle(questionObj.options[3], for: UIControlState.normal)
            default: print("Question Type Not Accepted")
            }
            
            
            askedQuestions.append(indexOfSelectedQuestion)
        } else {
            displayQuestion()
        }
    }
    
    func displayScore() {
        // Hide the answer buttons
        ButtonA.isHidden = true
        ButtonB.isHidden = true
        ButtonC.isHidden = true
        ButtonD.isHidden = true
        answerResponse.isHidden = true
        
        // Display plavargain button
        playAgainButton.isHidden = false
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        let scorePercentage: Double = Double(correctQuestions) / Double(questionsPerRound)
        if (scorePercentage >= 0.5) {
            playGoodGameSound()
        } else {
            playBadGameSound()
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        var showCorrectButton: [Int:UIButton] = [0: ButtonA, 1: ButtonB, 2: ButtonC, 3: ButtonD]
        let selectedQuestionObj = triviaModel[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionObj.answer
        answerResponse.isHidden = false

        switch triviaModel[indexOfSelectedQuestion].type {
        case QuestionType.truefalse:
            if (sender === ButtonA && correctAnswer == 1) || (sender === ButtonB && correctAnswer == 0) {
                correctQuestions += 1
                playAnswerCorrectSound()
                answerResponse.text = correctTxt
                answerResponse.textColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                if sender === ButtonA {
                    ButtonA.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                } else {
                    ButtonB.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                }
            } else {
                playanswerIncorrectSound()
                answerResponse.text = incorrectTxt
                answerResponse.textColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                if sender === ButtonA {
                    ButtonA.backgroundColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                    ButtonB.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                } else {
                    ButtonA.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                    ButtonB.backgroundColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                }
            }
        case QuestionType.fourOption:
            if (sender === ButtonA && correctAnswer == 0) ||
               (sender === ButtonB && correctAnswer == 1) ||
               (sender === ButtonC && correctAnswer == 2) ||
               (sender === ButtonD && correctAnswer == 3) {
                correctQuestions += 1
                answerResponse.text = correctTxt
                answerResponse.textColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                playAnswerCorrectSound()
                switch sender {
                case _ where sender === ButtonA:
                    ButtonA.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                case _ where sender === ButtonB:
                    ButtonB.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                case _ where sender === ButtonC:
                    ButtonC.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                case _ where sender === ButtonD:
                    ButtonD.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                default: print("Not a valid button")
                }
                
            } else {
                answerResponse.text = incorrectTxt
                answerResponse.textColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                playanswerIncorrectSound()
                switch sender {
                case _ where sender === ButtonA:
                    ButtonA.backgroundColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                    showCorrectButton[correctAnswer]?.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                case _ where sender === ButtonB:
                    ButtonB.backgroundColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                    showCorrectButton[correctAnswer]?.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                case _ where sender === ButtonC:
                    ButtonC.backgroundColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                    showCorrectButton[correctAnswer]?.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                case _ where sender === ButtonD:
                    ButtonD.backgroundColor = UIColor(red: (210/255), green: (39/255), blue: (29/255), alpha: 1.0)
                    showCorrectButton[correctAnswer]?.backgroundColor = UIColor(red: (94/255), green: (207/255), blue: (78/255), alpha: 1.0)
                default: print("Not a valid button")
                }
            }
        default: print("Not a valid question type")
        }
        loadNextRoundWithDelay(seconds: 1)
    }
    
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        ButtonA.isHidden = false
        ButtonB.isHidden = false
        ButtonC.isHidden = false
        ButtonD.isHidden = false
        askedQuestions.removeAll()
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func setStartBackgroundColor() {
        ButtonA.backgroundColor = UIColor(red: (12/255),  green: (121/255), blue: (150/255), alpha: 1.0)
        ButtonB.backgroundColor = UIColor(red: (12/255),  green: (121/255), blue: (150/255), alpha: 1.0)
        ButtonC.backgroundColor = UIColor(red: (12/255),  green: (121/255), blue: (150/255), alpha: 1.0)
        ButtonD.backgroundColor = UIColor(red: (12/255),  green: (121/255), blue: (150/255), alpha: 1.0)
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "gamestart", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &startSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(startSound)
    }
    
    func loadAnswerCorrectSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "correctsound", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &correctSound)
    }
    
    func playAnswerCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func loadAnswerIncorrectSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "incorrectsound", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &incorrectSound)
    }
    
    func playanswerIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
    
    func loadGoodGameSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "goodRound", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &goodGame)
    }
    
    func playGoodGameSound() {
        AudioServicesPlaySystemSound(goodGame)
    }
    
    func loadBadGameSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "badgame", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &badGame)
    }
    
    func playBadGameSound() {
        AudioServicesPlaySystemSound(badGame)
    }
}
