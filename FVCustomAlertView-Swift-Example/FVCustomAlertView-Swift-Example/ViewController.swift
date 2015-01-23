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
        FVCustomAlertView.shareInstance.showDefaultErrorAlertOnView(self.view, withTitle: "Error",
            withSize: CGSizeMake(200, 100))
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            NSThread.sleepForTimeInterval(2)
            dispatch_async(dispatch_get_main_queue(), {
                FVCustomAlertView.shareInstance.showDefaultErrorAlertOnView(self.view, withTitle: "Another",
                    withSize: CGSizeMake(150, 150))
            });
        });
    }

    @IBAction func showWarning(sender: AnyObject) {
        FVCustomAlertView.shareInstance.showDefaultWarningAlertOnView(self.view, withTitle: "Warning")
    }

    @IBAction func showSwitch(sender: AnyObject) {
        let sw = UISwitch()
        sw.on = true
        FVCustomAlertView.shareInstance.showAlertOnView(self.view, withTitle: "1 + 1 = 2 ?", titleColor: UIColor.blackColor(), width: 200, height: 150, backgroundImage: nil, backgroundColor: UIColor.orangeColor(), cornerRadius: 5, shadowAlpha: 0.1, alpha: 0.9, contentView: sw, type: .Custom)
    }
}

