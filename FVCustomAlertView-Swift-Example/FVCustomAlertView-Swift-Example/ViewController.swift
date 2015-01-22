//
//  ViewController.swift
//  FVCustomAlertView-Swift-Example
//
//  Created by Garnel Mao on 1/22/15.
//  Copyright (c) 2015 maogm12@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showLoading(sender: AnyObject) {
        FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(self.view, withTitle: "Loading")
    }


    @IBAction func showDone(sender: AnyObject) {
        FVCustomAlertView.shareInstance.showDefaultDoneAlertOnView(self.view, withTitle: "Done")
    }

    @IBAction func showError(sender: AnyObject) {
        FVCustomAlertView.shareInstance.showDefaultErrorAlertOnView(self.view, withTitle: "Error")
    }

    @IBAction func showWarning(sender: AnyObject) {
        FVCustomAlertView.shareInstance.showDefaultWarningAlertOnView(self.view, withTitle: "Warning")
    }
}

