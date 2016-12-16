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
    var quizType: QuestionType = QuestionType.mathquiz
    var correctButton: Int = 0
    let backgroundImage = UIColor(patternImage: UIImage(named: "titlebackground.jpg")!)
    var quizID: Int = 2
    var correctAnswer: Int = 0
    
    // Button references
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerResponse: UILabel!
    @IBOutlet weak var ButtonA: UIButton!
    @IBOutlet weak var ButtonB: UIButton!
    @IBOutlet weak var ButtonC: UIButton!
    @IBOutlet weak var ButtonD: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var bossTitle: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundImage
        loadGameSounds()
        playSound(sound: startSound)
        setStartBackgroundColor()
        setHomeUI()
        // Start game
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Home navigation to go back to home ui
    @IBAction func goHome(_ sender: UIButton) {
        if (sender === home) {
            viewDidLoad()
            askedQuestions.removeAll()
            questionsAsked = 0
            correctQuestions = 0
        }
    }
    
    // Home UI
    func setHomeUI() {
        bossTitle.isHidden = false
        ButtonB.setTitle("Start Trivia Game", for: UIControlState.normal)
        ButtonC.setTitle("Start Math Game", for: UIControlState.normal)
        ButtonA.isHidden = true
        ButtonB.isHidden = false
        ButtonC.isHidden = false
        ButtonD.isHidden = true
        questionField.isHidden = true
        playAgainButton.isHidden = true
        answerResponse.isHidden = true
        home.isHidden = true
    }
    
    // Quiz UI
    func setQuizUI() {
        home.isHidden = false
        bossTitle.isHidden = true
        ButtonA.isHidden = false
        ButtonB.isHidden = false
        ButtonC.isHidden = false
        ButtonD.isHidden = false
        questionField.isHidden = false
    }
    
    // Displays math problem
    func displayProblem() {
        setQuizUI()
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
    
    // Displays trivia question
    func displayQuestion() {
        setQuizUI()
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaModel.count)
        let questionObj = triviaModel[indexOfSelectedQuestion]
        setStartBackgroundColor()
        quizType = questionObj.type
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
        // check which quiz type is in play
        if (sender.currentTitle == "Start Trivia Game") {
            quizID = 0
            displayQuestion()
            } else if (sender.currentTitle == "Start Math Game") {
            quizID = 1
            displayProblem()
            } else {
        // Increment the questions asked counter
        questionsAsked += 1
        var showCorrectButton: [Int:UIButton] = [0: ButtonA, 1: ButtonB, 2: ButtonC, 3: ButtonD]
        let selectedQuestionObj = triviaModel[indexOfSelectedQuestion]
        correctAnswer = selectedQuestionObj.answer
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
            if (sender === ButtonA && correctAnswer == 0) ||
               (sender === ButtonB && correctAnswer == 1) ||
               (sender === ButtonC && correctAnswer == 2) ||
               (sender === ButtonD && correctAnswer == 3) {
                
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
            correctAnswer = correctButton
            if (sender === ButtonA && correctAnswer == 0) ||
               (sender === ButtonB && correctAnswer == 1) ||
               (sender === ButtonC && correctAnswer == 2) ||
               (sender === ButtonD && correctAnswer == 3) {
                
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
        }
        loadNextRoundWithDelay(seconds: 1)
        }
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
        ButtonA.backgroundColor = ColorWheel().black
        ButtonB.backgroundColor = ColorWheel().black
        ButtonC.backgroundColor = ColorWheel().black
        ButtonD.backgroundColor = ColorWheel().black
    }
}
