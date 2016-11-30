//
//  TriviaModel.swift
//  TrueFalseStarter
//
//  Created by Nathan Rohweder on 11/22/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

struct TriviaModel {
    let trivia: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"],
        ["Question": "This was the only US President to serve more than two consecutive terms.", "Answer": "2"],
        ["Question": "Which of the following countries has the most residents?", "Answer": "1"],
        ["Question": "In what year was the United Nations founded?", "Answer": "3"],
        ["Question": "The Titanic departed from the United Kingdom, where was it supposed to arrive?", "Answer": "3"],
        ["Question": "Which nation produces the most oil?", "Answer": "4"],
        ["Question": "Which country has most recently won consecutive World Cups in Soccer?", "Answer": "2"],
        ["Question": "Which of the following rivers is longest?", "Answer": "2"],
        ["Question": "Which city is the oldest?", "Answer": "1"],
        ["Question": "Which country was the first to allow women to vote in national elections?", "Answer": "1"],
        ["Question": "Which of these countries won the most medals in the 2012 Summer Games?", "Answer": "4"]
    ]
    var askedQuestions: [String] = []
    let correct = "Correct!"
    let incorrect = "Sorry, wrong answer!"
}
