//
//  FVCustomAlertView.swift
//  FVCustomAlertView-Swift
//
//  Ported from FVCustomAlertView(https://github.com/thegameg/FVCustomAlertView)
//
//  Created by Garnel Mao on 1/22/15.

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2014 Francis Visoiu Mistrih.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/**
FVAlertType definitions
*/
public enum FVAlertType {
    /** A view with a UIActivityIndicator and "Loading..." title. */
    case Loading
    /** A view with a checkmark and "Done" title. */
    case Done
    /** A view with a cross and "Error" title. */
    case Error
    /** A view with an exclamation point and "Warning" title. */
    case Warning
    /** A view with a background shadow. */
    case Custom
}

/**
* Displays a custom alert view. It can contain either a title or a custom UIView
* The view is customisable and has 4 default modes:
* - FVAlertTypeLoading - displays a UIActivityIndicator
* - FVAlertTypeDone/Error/Warning - displays a checkmark/cross/exclamation point
* - FVAlertTypeCustom - lets the user to customise the view
*/
public class FVCustomAlertView: UIView {
    /**
    * Use singleton pattern to hold the share instance
    * see more: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    */
    class var shareInstance: FVCustomAlertView {
        struct Static {
            static var instance: FVCustomAlertView?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = FVCustomAlertView()
        }

        return Static.instance!
    }

    private let kInsetValue: CGFloat = 6
    private let kFinalViewTag: Int = 1337
    private let kAlertViewTag: Int = 1338
    private let kFadeOutDuration: NSTimeInterval = 0.5
    private let kActivityIndicatorSize: CGFloat = 50
    private let kOtherIconsSize: CGFloat = 30

    private var _currentView: UIView?

    /**
    * Getter to the current FVCustomAlertView displayed
    * If no alert view is displayed on the screen, the result will be nil
    */
    public private(set) var currentView: UIView? {
        get {
            return _currentView
        }

        set {
            _currentView = newValue
        }
    }

    public func showAlertOnView(view: UIView, withTitle title: String?, titleColor: UIColor, width: CGFloat, height: CGFloat, backgroundImage: UIImage?, backgroundColor: UIColor?, cornerRadius: CGFloat, shadowAlpha: CGFloat, alpha: CGFloat, contentView: UIView?, type: FVAlertType) {
        // hide current alertView first
        if currentView != nil {
            // must be false
            hideAlertFromView(currentView, fading: false)
        }

        // the view is not added to a window yet
        if view.window == nil {
            return
        }

        if view.viewWithTag(kFinalViewTag) != nil {
            println("Can't add two FVCustomAlertViews on the same view. Hide the current view first.")
            return
        }

        // get window size and position
        let windowRect = UIScreen.mainScreen().bounds

        // create the final view with a special tag
        let resultView = UIView(frame: windowRect)
        resultView.tag = kFinalViewTag

        // create a shadow view by adding a black background with custom opacity
        let shadowView = UIView(frame: windowRect)
        shadowView.backgroundColor = UIColor.blackColor()
        shadowView.alpha = shadowAlpha
        resultView.addSubview(shadowView)

        // create the main alert view centered
        // with custom width and height
        // and custom background
        // and custom corner radius
        // and custom opacity
        let alertView = UIView(frame: CGRectMake(windowRect.size.width / 2 - width / 2, windowRect.size.height / 2 - height / 2, width, height))
        alertView.tag = kAlertViewTag //set tag to retrieve later

        // set background color
        // if a background image is used, use the image instead
        alertView.backgroundColor = backgroundColor
        if backgroundImage != nil {
            alertView.backgroundColor = UIColor(patternImage: backgroundImage!)
        }
        alertView.layer.cornerRadius = cornerRadius
        alertView.alpha = alpha

        // create the title label centered with multiple lines
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = titleColor

        // set the number of lines to 0 (unlimited)
        // set the maximum size to the label
        // then get the size that fits the maximum size
        titleLabel.numberOfLines = 0
        let requiredSize = titleLabel.sizeThatFits(CGSizeMake(width - kInsetValue, height - kInsetValue))
        titleLabel.frame = CGRectMake(width / 2 - requiredSize.width / 2, kInsetValue, requiredSize.width, requiredSize.height)
        alertView.addSubview(titleLabel)

        // check wheather the alert is of custom type or not
        // if it is, set the custom view
        if type != .Custom || contentView != nil {
            let content = type == .Custom ? contentView! : self.contentViewFromType(type)

            content.frame = CGRectApplyAffineTransform(content.frame, CGAffineTransformMakeTranslation(width / 2 - content.frame.size.width / 2, titleLabel.frame.origin.y + titleLabel.frame.size.height + kInsetValue))

            alertView.addSubview(content)
        }

        resultView.addSubview(alertView)

        // tap the alert view to hide and remove it from the superview
        let tapGesture = UITapGestureRecognizer(target: self, action: "hideAlertByTap:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        resultView.addGestureRecognizer(tapGesture)

        // use view's window to let result view cover fullscreen
        view.window?.addSubview(resultView)
        currentView = view
    }

    public func showDefaultLoadingAlertOnView(view: UIView, withTitle title: String) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: 100.0, height: 100.0, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Loading)
    }

    public func showDefaultDoneAlertOnView(view: UIView, withTitle title: String) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: 100.0, height: 100.0, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Done)
    }

    public func showDefaultErrorAlertOnView(view: UIView, withTitle title: String) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: 100.0, height: 100.0, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Error)
    }

    public func showDefaultWarningAlertOnView(view: UIView, withTitle title: String) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: 100.0, height: 100.0, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Warning)
    }

    public func showDefaultLoadingAlertOnView(view: UIView, withTitle title: String, withSize size: CGSize) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: size.width, height: size.height, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Loading)
    }

    public func showDefaultDoneAlertOnView(view: UIView, withTitle title: String, withSize size: CGSize) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: size.width, height: size.height, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Done)
    }

    public func showDefaultErrorAlertOnView(view: UIView, withTitle title: String, withSize size: CGSize) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: size.width, height: size.height, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Error)
    }

    public func showDefaultWarningAlertOnView(view: UIView, withTitle title: String, withSize size: CGSize) {
        self.showAlertOnView(view, withTitle: title, titleColor: UIColor.whiteColor(), width: size.width, height: size.height, backgroundImage: nil, backgroundColor: UIColor.blackColor(), cornerRadius: 10.0, shadowAlpha: 0.1, alpha: 0.8, contentView: nil, type: .Warning)
    }

    public func contentViewFromType(type: FVAlertType) -> UIView {
        let content = UIImageView()
        // generate default content view based on the type of the alert
        switch type {
        case .Loading:
            let spin = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            spin.startAnimating()
            return spin
        case .Done:
            content.frame = CGRectMake(0, kInsetValue, kOtherIconsSize, kOtherIconsSize)
            content.image = UIImage(named: "checkmark")
        case .Error:
            content.frame = CGRectMake(0, kInsetValue, kOtherIconsSize, kOtherIconsSize)
            content.image = UIImage(named: "cross")
        case .Warning:
            content.frame = CGRectMake(0, kInsetValue, kOtherIconsSize, kOtherIconsSize)
            content.image = UIImage(named: "warning")
        default:
            // FVAlertTypeCustom never reached
            break
        }

        return content
    }

    public func fadeOutView(view: UIView?, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(kFadeOutDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                view?.alpha = 0
                return
            },
            completion: completion
        )
    }

    public func hideAlertFromView(view: UIView?, fading: Bool) {
        let alertView = view?.window?.viewWithTag(kFinalViewTag)
        if fading {
            fadeOutView(alertView, completion: { (finished) in
                alertView?.removeFromSuperview()
                return
            })
        } else {
            alertView?.removeFromSuperview()
        }

        // TODO maybe check view is currentView
        currentView = nil
    }

    public func hideAlertByTap(sender: UITapGestureRecognizer) {
        self.fadeOutView(sender.view, completion: {(finished) in
            sender.view?.viewWithTag(self.kFinalViewTag)?.removeFromSuperview()
            self.currentView = nil
        })
    }
}






