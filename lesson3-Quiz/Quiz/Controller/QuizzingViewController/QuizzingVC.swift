//
//  QuizingVC.swift
//  lesson3-Quiz
//
//  Created by Иван longrail on 17/03/2019.
//  Copyright © 2019 Иван longrail. All rights reserved.
//

import UIKit

class QuizzingVC: UIViewController {

    var players: Player!
    var enteredPlayerName: String!

    var quiz: Quiz!
    var indexOfCurrentQuestion = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownProgressView: UIProgressView!
    @IBOutlet weak var quizProgressView: UIProgressView!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var rangeStackView: UIStackView!
    @IBOutlet weak var multipleStackView: UIStackView!
    
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    @IBOutlet weak var multipleButton: UIButton!
    
    @IBOutlet weak var rengedSlider: UISlider!
    @IBOutlet var rengedLabels: [UILabel]!
    @IBOutlet weak var rengedButton: UIButton!
    
    var timerCount: (current: Double,total: Double) = (0,1)
    var timer: Timer?
    var startLucky: Double?
    var viewBackgroundColor: UIColor!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBackgroundColor = view.backgroundColor
        updateUI()
    }
    
    func updateUI() {
        singleStackView.isHidden = true
        rangeStackView.isHidden = true
        multipleStackView.isHidden = true
        countdownLabel.isHidden = true
        countdownProgressView.isHidden = true
    
        navigationItem.title = quiz.quizName
        
        let currentQuestion = quiz.questions[indexOfCurrentQuestion]
    
        
        if currentQuestion.timerProperty != .none {
            countdownLabel.isHidden = false
            countdownProgressView.isHidden = false
            timerCount = (current: currentQuestion.timerProperty.rawValue,
                              total: currentQuestion.timerProperty.rawValue)
        
            countdownProgressView.setProgress(1, animated: false)
        
            startLucky = Double.random(in: 0 ... timerCount.total) //* 2 )
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeCountdown(timer:)), userInfo: nil, repeats: true)
        }
        
        questionLabel.text = """
        \(indexOfCurrentQuestion + 1) / \(quiz.questions.count)
        \(currentQuestion.text)
        """
        
        let totalProgress = Float(indexOfCurrentQuestion) / Float(quiz.questions.count)
        quizProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.responceProperty {
        case .single:
            singleStackView.isHidden = false
            updateSingleStack()
        case .range:
            rangeStackView.isHidden = false
            updateRangeStack()
        case .multipal:
            multipleStackView.isHidden = false
            updateMultipleStack()
        }
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        rengedLabels[2].text = String(Int(rengedSlider.value))
    }
    
    @objc func changeCountdown(timer: Timer) {
        let currentQuestion = quiz.questions[indexOfCurrentQuestion]
        
        if timerCount.current > 0 {
            timerCount.current -= 0.1
            countdownLabel.text = String(Int(timerCount.current))
            countdownProgressView.setProgress(Float(timerCount.current / timerCount.total), animated: true)
            
            if currentQuestion.luckyProperty != .none {
                let c = timerCount.current
                let t = timerCount.total
                let s = startLucky!
                let luckyDuration: Double = 2 // seconds
                if timerCount.current > startLucky!, timerCount.current < (startLucky! + luckyDuration) {
                    countdownLabel.text = "LUCKY TIME!"
                    view.backgroundColor = UIColor.black
                } else {
                    view.backgroundColor = viewBackgroundColor
                }
            }
            
        } else {
            timer.invalidate()
        }
    }
}
