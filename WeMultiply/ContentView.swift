//
//  ContentView.swift
//  WeMultiply
//
//  Created by Bill Plantz on 4/14/21.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplicationTableSelected = 1
    let gameLength = ["5", "10", "15", "20"]
    @State private var numberOfQuestionsString = "5"
    
    @State private var inGame = false
    
    @State private var questionBank: [Question] = []
    @State private var currentQuestion = 1
    @State private var score = 0
    @State private var userAnswer = ""
    @State private var revealAnswer = ""
    @State private var isGameOver = false
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // HeadingView
                VStack {
                    Text("Who Wants to be a")
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .font(.largeTitle)
                    Text("Multiplier")
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                        .font(.system(size: 60, weight: .bold, design: .default))
                }
                .padding(30)
                
                if inGame {
                    // GameView
                    VStack {
                        Spacer()
                        Text("Question #\(currentQuestion)")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .regular, design: .default))
                        Text("\(questionBank[currentQuestion - 1].questionText)")
                            .font(.system(size: 60, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Spacer()
                        Text("Answer")
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .medium, design: .default))
                        TextField("Type here...", text: $userAnswer)
                            .frame(width: 150, alignment: .center)
                            //                .overlay(Circle(), alignment: .center)
                            //                .foregroundColor(.white)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .padding()
                        Text("Score: \(score)")
                        
                        Button(action: {
                            revealAnswer = checkAnswer()
                        }, label: {
                            Text("Check Answer")
                                .frame(width: 200, height: 60, alignment: .center)
                                .background(Color.white)
                                .foregroundColor(.purple)
                                .font(.system(size: 24, weight: .semibold))
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .padding()
                        })
                        
                        Button(action: {
                            inGame.toggle()
                        }, label: {
                            Text("New Game")
                                .foregroundColor(.white)
                                .font(.body)
                        })
                    }
                    .padding()
                    .alert(isPresented: $isGameOver, content: {
                        Alert(title: Text("Game Over!"), message: Text("Your score is \(score)"), dismissButton: .destructive(Text("Okay"), action: {
                            inGame = false
                            multiplicationTableSelected = 1
                            numberOfQuestionsString = "5"
                            questionBank = []
                            currentQuestion = 1
                            score = 0
                        }))
                    })
                } else {
                    // SettingsView
                    VStack(alignment: .leading) {
                        Text("What level?")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        HStack {
                            Text("Multiplication Table")
                                .foregroundColor(.white)
                            Stepper("\(multiplicationTableSelected)", value: $multiplicationTableSelected, in: 1...12)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("How many questions?")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        Picker("Number of Questions", selection: $numberOfQuestionsString) {
                            ForEach(0 ..< gameLength.count) {
                                Text(gameLength[$0]).tag(gameLength[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    
                    Button(action: {
                        inGame.toggle()
                        generateQuestions()
                    }) {
                        Text("Start Game")
                            .frame(width: 200, height: 60, alignment: .center)
                            .background(Color.white)
                            .foregroundColor(.purple)
                            .font(.system(size: 24, weight: .semibold))
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .padding()
                    }
                }
                Spacer()
            }
            .preferredColorScheme(.dark)
        }
    }
    
    func generateQuestions() {
        let numberOfQuestions = Int(numberOfQuestionsString) ?? 5
        var multipliers: [Int] = []
        
        questionBank.removeAll()
        for question in 0...numberOfQuestions - 1 {
            for i in (0...12).shuffled() {
                multipliers.append(i)
            }
            let question = Question(questionText: "\(multiplicationTableSelected) X \(multipliers[question])", answer: multiplicationTableSelected * multipliers[question])
            questionBank.append(question)
        }
        print(questionBank)
    }
    
    func checkAnswer() -> String {
        var message = ""
        let numberOfQuestions = Int(numberOfQuestionsString) ?? 5
        
        if let userAnswerInt = Int(userAnswer) {
            if userAnswerInt == questionBank[currentQuestion - 1].answer {
                score += 10
//                message = "Correct, add 10 points!"
            } else {
//                message = "Good try! The correct answer is \(questionBank[currentQuestion].answer)."
            }
            if currentQuestion < numberOfQuestions {
                currentQuestion += 1
            } else {
                isGameOver = true
            }
        }
        userAnswer = ""
        return "message"
    }
}

struct Question {
    var questionText: String
    var answer: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
