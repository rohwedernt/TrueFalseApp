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
        
        switch backgroundID {
        case 1: self.view.backgroundColor = BackgroundImages().space
        case 2: self.view.backgroundColor = BackgroundImages().beach
        case 3: self.view.backgroundColor = BackgroundImages().landscape
        default: print("Background not available")
        }
        loadGameSounds()
        
        // Start game
        playSound(sound: startSound)
        selectQuiz()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectQuiz() {
        if (quizID == 0) {
            displayQuestion()
        } else if quizID == 1 {
            displayProblem()
        }
    }
    
    var correctButton: Int = 0
    
    func displayProblem() {
        setStartBackgroundColor()
        let buttonCorrect = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        let firstTerm = GKRandomSource.sharedRandom().nextInt(upperBound: 50)
        let secondTerm = GKRandomSource.sharedRandom().nextInt(upperBound: 50)
        let answer = firstTerm + secondTerm
        questionField.text = "\(firstTerm) + \(secondTerm)"
        var buttonOptions: [Int:UIButton] = [0: ButtonA, 1: ButtonB, 2: ButtonC, 3: ButtonD]
        for i in 0...3 {
            if (i == buttonCorrect) {
                buttonOptions[i]?.setTitle(String(answer), for: UIControlState.normal)
                correctButton = i
            } else {
                buttonOptions[i]?.setTitle(String(GKRandomSource.sharedRandom().nextInt(upperBound: 100)), for: UIControlState.normal)
            }
        }
    }
    
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
                ButtonA.setTitle(questionObj.options[1], for: UIControlState.normal)
                ButtonB.setTitle(questionObj.options[0], for: UIControlState.normal)
                ButtonC.isHidden = true
                ButtonD.isHidden = true
            case QuestionType.fourOption:
                ButtonA.setTitle(questionObj.options[0], for: UIControlState.normal)
                ButtonB.setTitle(questionObj.options[1], for: UIControlState.normal)
                ButtonC.setTitle(questionObj.options[2], for: UIControlState.normal)
                ButtonD.setTitle(questionObj.options[3], for: UIControlState.normal)
                ButtonC.isHidden = false
                ButtonD.isHidden = false
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
        
        // Display play again button
        playAgainButton.isHidden = false
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        let scorePercentage: Double = Double(correctQuestions) / Double(questionsPerRound)
        if (scorePercentage >= 0.5) {
            playSound(sound: goodGame)
        } else {
            playSound(sound: badGame)
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        var quizType: QuestionType
        if (quizID == 0) {
            quizType = triviaModel[indexOfSelectedQuestion].type
        } else {
            quizType = QuestionType.mathquiz
        }
        questionsAsked += 1
        var showCorrectButton: [Int:UIButton] = [0: ButtonA, 1: ButtonB, 2: ButtonC, 3: ButtonD]
        let selectedQuestionObj = triviaModel[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionObj.answer
        answerResponse.isHidden = false
        
        switch quizType {
        case QuestionType.truefalse:
            if (sender === ButtonA && correctAnswer == 1) || (sender === ButtonB && correctAnswer == 0) {
                correctQuestions += 1
                playSound(sound: correctSound)
                answerResponse.text = correctResponse
                answerResponse.textColor = ColorWheel().green
                if sender === ButtonA {
                    ButtonA.backgroundColor = ColorWheel().green
                } else {
                    ButtonB.backgroundColor = ColorWheel().green
                }
            } else {
                playSound(sound: incorrectSound)
                answerResponse.text = incorrectResponse
                answerResponse.textColor = ColorWheel().red
                if sender === ButtonA {
                    ButtonA.backgroundColor = ColorWheel().red
                    ButtonB.backgroundColor = ColorWheel().green
                } else {
                    ButtonA.backgroundColor = ColorWheel().green
                    ButtonB.backgroundColor = ColorWheel().red
                }
            }
        case QuestionType.fourOption:
            if (sender === ButtonA && correctButton == 0) ||
               (sender === ButtonB && correctButton == 1) ||
               (sender === ButtonC && correctButton == 2) ||
               (sender === ButtonD && correctButton == 3) {
                
                correctQuestions += 1
                answerResponse.text = correctResponse
                answerResponse.textColor = ColorWheel().green
                playSound(sound: correctSound)
                
                switch sender {
                case _ where sender === ButtonA:
                    ButtonA.backgroundColor = ColorWheel().green
                case _ where sender === ButtonB:
                    ButtonB.backgroundColor = ColorWheel().green
                case _ where sender === ButtonC:
                    ButtonC.backgroundColor = ColorWheel().green
                case _ where sender === ButtonD:
                    ButtonD.backgroundColor = ColorWheel().green
                default: print("Not a valid button")
                    
                }
                
            } else {
                answerResponse.text = incorrectResponse
                answerResponse.textColor = ColorWheel().red
                playSound(sound: incorrectSound)
                switch sender {
                case _ where sender === ButtonA:
                    ButtonA.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                case _ where sender === ButtonB:
                    ButtonB.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                case _ where sender === ButtonC:
                    ButtonC.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                case _ where sender === ButtonD:
                    ButtonD.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                default: print("Not a valid button")
                }
            }
        case QuestionType.mathquiz:
            if (sender === ButtonA && correctButton == 0) ||
               (sender === ButtonB && correctButton == 1) ||
               (sender === ButtonC && correctButton == 2) ||
               (sender === ButtonD && correctButton == 3) {
                
                correctQuestions += 1
                answerResponse.text = correctResponse
                answerResponse.textColor = ColorWheel().green
                playSound(sound: correctSound)
                
                switch sender {
                case _ where sender === ButtonA:
                    ButtonA.backgroundColor = ColorWheel().green
                case _ where sender === ButtonB:
                    ButtonB.backgroundColor = ColorWheel().green
                case _ where sender === ButtonC:
                    ButtonC.backgroundColor = ColorWheel().green
                case _ where sender === ButtonD:
                    ButtonD.backgroundColor = ColorWheel().green
                default: print("Not a valid button")
                }
                
            } else {
                answerResponse.text = incorrectResponse
                answerResponse.textColor = ColorWheel().red
                playSound(sound: incorrectSound)
                
                switch sender {
                case _ where sender === ButtonA:
                    ButtonA.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                case _ where sender === ButtonB:
                    ButtonB.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                case _ where sender === ButtonC:
                    ButtonC.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
                case _ where sender === ButtonD:
                    ButtonD.backgroundColor = ColorWheel().red
                    showCorrectButton[correctAnswer]?.backgroundColor = ColorWheel().green
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
            if (quizID == 0) {
                displayQuestion()
            } else if quizID == 1 {
                displayProblem()
            }
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
        ButtonA.backgroundColor = ColorWheel().teal
        ButtonB.backgroundColor = ColorWheel().teal
        ButtonC.backgroundColor = ColorWheel().teal
        ButtonD.backgroundColor = ColorWheel().teal
    }
    
    func loadGameSounds() {
        let pathToGameStartFile = Bundle.main.path(forResource: "gamestart", ofType: "mp3")
        let gameStartURL = URL(fileURLWithPath: pathToGameStartFile!)
        AudioServicesCreateSystemSoundID(gameStartURL as CFURL, &startSound)
        
        let pathToCorrectSoundFile = Bundle.main.path(forResource: "correctsound", ofType: "mp3")
        let correctSoundURL = URL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL as CFURL, &correctSound)
        
        let pathToIncorrectSoundFile = Bundle.main.path(forResource: "incorrectsound", ofType: "mp3")
        let incorrectSoundURL = URL(fileURLWithPath: pathToIncorrectSoundFile!)
        AudioServicesCreateSystemSoundID(incorrectSoundURL as CFURL, &incorrectSound)
        
        let pathToGoodGameFile = Bundle.main.path(forResource: "goodRound", ofType: "mp3")
        let GoodGameURL = URL(fileURLWithPath: pathToGoodGameFile!)
        AudioServicesCreateSystemSoundID(GoodGameURL as CFURL, &goodGame)
        
        let pathToBadGameFile = Bundle.main.path(forResource: "badgame", ofType: "mp3")
        let BadGameURL = URL(fileURLWithPath: pathToBadGameFile!)
        AudioServicesCreateSystemSoundID(BadGameURL as CFURL, &badGame)
    }
    
    func playSound(sound: SystemSoundID) {
        AudioServicesPlaySystemSound(sound)
    }
}
