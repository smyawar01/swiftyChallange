//
//  ViewController.swift
//  SwiftyChallenge
//
//  Created by Monish Syed  on 10/08/2020.
//  Copyright © 2020 Monish Syed . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var btnAnswers: [UIButton]!
    @IBOutlet var answers: [UILabel]!
    var viewModel: QuestionViewModel?
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var questionBackground: UIView!
    @IBOutlet weak var question: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submit.layer.cornerRadius = 5
        questionBackground.layer.cornerRadius = 10
        questionBackground.layer.masksToBounds = true
        question.text = "We can return multiple values from a function using?"
        setup()
    }
    private func setup() {
        
        //Need to find a way to inject using storyboard.
        self.viewModel = QuestionFactory().makeModel()
        self.bindings()
        self.viewModel?.load()
    }
    private func bindings() {
        
        self.viewModel?.onChangeState = { [weak self] state in
            
            guard let self = self else { return }
            switch state {
            case .error:
                print("Error........")
            case .loaded(let question):
                
                self.question.text = question.query
                for (index, answer) in self.answers.enumerated() {
                    
                    answer.text = question.answers[index].title
                }
            case .answered(let title, let message):
                
                let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
                let action = UIAlertAction(title: "OK",
                                           style: .cancel) { _ in
                    
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert,
                             animated: true,
                             completion: nil)
            }
        }
    }
    
    @IBAction func onSelectChoice(_ sender: UIButton) {
        
        for btnAnswer in btnAnswers {
            btnAnswer.isSelected = false
        }
        sender.isSelected = true
    }
    @IBAction func onSubmit(_ sender: UIButton) {
        
        if let index = self.btnAnswers.firstIndex(where: { $0.isSelected == true }) {
            
            self.viewModel?.submit(choice: index)
        }
    }
}

