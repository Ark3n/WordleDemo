//
//  MainViewController.swift
//  WordleDemo
//
//  Created by Arken Sarsenov on 06.03.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    let answers = ["later", "bloke", "there", "false", "ultra"]
    var answer = ""
    private var guesses: [[Character?]]  = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    let keyboardVC = KeyboardViewConroller()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        answer = answers.randomElement() ?? "after"
        addChildren()
    }
    func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.datasource = self
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension MainViewController: KeyboardViewConrollerDlegate {
    func keyboardViewConroller(_ vc: KeyboardViewConroller, didTapKey letter: Character) {
         //Update guesses
        var stop  = false
        
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        
        boardVC.reloadData()
    }
}

extension MainViewController: BoardViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        
        let rowIndex = indexPath.section
        let count = guesses[rowIndex].compactMap({$0}).count
        guard count == 5 else {
            return nil
        }
        let indexedAnswer = Array(answer)
        guard let letter  = guesses[indexPath.section][indexPath.row], indexedAnswer.contains(letter) else {
            return nil
        }
        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }
        return .systemOrange
    }
}

