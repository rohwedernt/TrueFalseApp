//
//  TriviaModel.swift
//  TrueFalseStarter
//
//  Created by Nathan Rohweder on 11/22/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

enum QuestionType {
    case truefalse
    case fourOption
    case threeOption
}

struct Question {
    let question: String
    let options: [String]
    let answer: String
    let type: QuestionType
}

let tfOptions = ["True", "False"]

let triviaModel: [Question] = [
    Question(
        question: "Only female koalas can whistle",
        options: tfOptions,
        answer: "False",
        type: QuestionType.truefalse),

    Question(
        question: "Blue whales are technically whales",
        options: tfOptions,
        answer: "True",
        type: QuestionType.truefalse),

    Question(
        question: "Camels are cannibalistic",
        options: tfOptions,
        answer: "False",
        type: QuestionType.truefalse),

    Question(
        question: "All ducks are birds",
        options: tfOptions,
        answer: "True",
        type: QuestionType.truefalse),

    Question(
        question: "This was the only US President to serve more than two consecutive terms",
        options: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"],
        answer: "2",
        type: QuestionType.fourOption),

    Question(
        question: "Which of the following countries has the most residents?",
        options: ["Nigeria", "Russia", "Iran", "Vietnam"],
        answer: "1",
        type: QuestionType.fourOption),

    Question(
        question: "In what year was the United Nations founded?",
        options: ["1918", "1919", "1945", "1954"],
        answer: "3",
        type: QuestionType.fourOption),

    Question(
        question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
        options: ["Paris", "Washington D.C.", "New York City", "Boston"],
        answer: "3",
        type: QuestionType.fourOption),

    Question(
        question: "Which nation produces the most oil?",
        options: ["Iran", "Iraq", "Brazil", "Canada"],
        answer: "4",
        type: QuestionType.fourOption),

    Question(
        question: "Which country has most recently won consecutive World Cups in Soccer?",
        options: ["Italy", "Brazil", "Argentinia", "Spain"],
        answer: "2",
        type: QuestionType.fourOption),

    Question(
        question: "Which of the following rivers is longest?",
        options: ["Yangtze", "Mississippi", "Congo", "Mekong"],
        answer: "2",
        type: QuestionType.fourOption),

    Question(
        question: "Which city is the oldest?",
        options: ["Mexico City", "Cape Town", "San Juan", "Sydney"],
        answer: "1",
        type: QuestionType.fourOption),

    Question(
        question: "Which country was the first to allow women to vote in national elections?",
        options: ["Poland", "United States", "Swedan", "Senegal"],
        answer: "1",
        type: QuestionType.fourOption),

    Question(
        question: "Which of these countries won the most medals in the 2012 Summer Games?",
        options: ["France", "Germany", "Japan", "Great Britain"],
        answer: "4",
        type: QuestionType.fourOption)]


var askedQuestions: [Int] = []
let correctTxt = "Correct!"
let incorrectTxt = "Sorry, wrong answer!"








