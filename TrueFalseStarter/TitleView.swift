//
//  TitleView.swift
//  TrueFalseStarter
//
//  Created by Nathan Rohweder on 12/5/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class TitleView: UIViewController {

    @IBOutlet weak var triviaQuiz: UIButton!
    @IBOutlet weak var mathQuiz: UIButton!
    @IBOutlet weak var background1: UIButton!
    @IBOutlet weak var background2: UIButton!
    @IBOutlet weak var background3: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start game
        background1.backgroundColor = UIColor(patternImage: UIImage(named: "starsbackground.jpg")!)
        background2.backgroundColor = UIColor(patternImage: UIImage(named: "beachbackground.jpg")!)
        background3.backgroundColor = UIColor(patternImage: UIImage(named: "landscapebackground.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func displayBackground(_ sender: UIButton) {
        if (sender === background1) {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "starsbackground.jpg")!)
            backgroundID = 1
        }
        
        if (sender === background2) {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "beachbackground.jpg")!)
            backgroundID = 2
        }
        
        if (sender === background3) {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "landscapebackground.jpg")!)
            backgroundID = 3
        }
    }
}
