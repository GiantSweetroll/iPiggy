//
//  ViewController.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 16/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class HomepageVC: UIViewController
{
    //MARK: Storyboard Elements
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelMoneyLeft: UILabel!
    @IBOutlet weak var labelGoalAmount: UILabel!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialization
        self.labelBudget.text = Methods.appendCurrency(string: "0")
        self.labelMoneyLeft.text = Methods.appendCurrency(string: "0")
        self.labelGoalAmount.text = Methods.appendCurrency(string: "0")
    }


}
