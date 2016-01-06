//
//  ViewController.swift
//  ShakeSample
//
//  Created by joinhov on 16/1/5.
//  Copyright © 2016年 lance. All rights reserved.
//

import UIKit
import AudioToolbox

private let animationOffset:CGFloat = 100;
// 摇一摇
class ViewController: UIViewController {
    
    var shakingSoundID:SystemSoundID = 0;
    
    var shakeUpImageView:UIImageView!;
    var shakeDownImageView:UIImageView!;
    var shakeUpLineImageView:UIImageView!;
    var shakeDownLineImageView:UIImageView!;
    
    var shakeBackgroundImageView:UIImageView!;
    
    var shakeView:UIView!;
    var bottomBar:UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blackColor();
        
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true;
        
        let audioPath = NSBundle.mainBundle().pathForResource("shake_sound_male", ofType: ".wav");
        print("audioPath: \(audioPath)");
        let audioUrl = NSURL(fileURLWithPath: audioPath!);
        // 创建一个声音id
        AudioServicesCreateSystemSoundID(audioUrl, &shakingSoundID);
        
        self.setup();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        self.shakeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 4 / 5);
        self.bottomBar.frame = CGRectMake(0, self.shakeView.frame.origin.y + CGRectGetHeight(self.shakeView.frame), self.view.frame.size.width, self.view.frame.size.height - self.shakeView.frame.size.height);
        self.shakeBackgroundImageView.frame = self.shakeView.bounds;
        self.shakeUpImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.shakeView.frame.size.height / 2);
        self.shakeUpLineImageView.frame = CGRectMake(0, CGRectGetMaxY(self.shakeUpImageView.frame) - 3, CGRectGetWidth(self.shakeUpImageView.bounds), 8);
        self.shakeDownImageView.frame = CGRectMake(0, CGRectGetMaxY(self.shakeUpImageView.frame), CGRectGetWidth(self.shakeUpImageView.frame), CGRectGetHeight(self.shakeView.frame) - CGRectGetHeight(self.shakeUpImageView.frame));
        self.shakeDownLineImageView.frame = CGRectMake(0, 3 - 8, CGRectGetWidth(self.shakeUpImageView.bounds), 8);
    }
    
    func setup() {
        self.shakeView = UIView();
        
        self.bottomBar = UIView();
        self.bottomBar.backgroundColor = UIColor.blackColor();
        
        self.shakeBackgroundImageView = UIImageView();
        self.shakeBackgroundImageView.image = UIImage(named: "ic_shake_logo_down");
        self.shakeBackgroundImageView.contentMode = .ScaleAspectFit;
        self.shakeView.addSubview(self.shakeBackgroundImageView);
        
        self.shakeUpImageView = UIImageView();
        self.shakeUpImageView.backgroundColor = self.view.backgroundColor;
        self.shakeUpImageView.userInteractionEnabled = false;
        self.shakeUpImageView.image = UIImage(named: "ic_shake_logo_up");
        self.shakeUpImageView.contentMode = UIViewContentMode.Bottom;
        
        self.shakeUpLineImageView = UIImageView();
        self.shakeUpLineImageView.hidden = true;
        shakeUpLineImageView.image = UIImage(named: "ic_shake_line_up");
        
        self.shakeUpImageView.addSubview(shakeUpLineImageView);
        
        self.shakeDownImageView = UIImageView();
        self.shakeDownImageView.backgroundColor = self.view.backgroundColor;
        self.shakeDownImageView.userInteractionEnabled = false;
        self.shakeDownImageView.image = UIImage(named: "ic_shake_logo_down");
        self.shakeDownImageView.contentMode = UIViewContentMode.Top;
        
        self.shakeDownLineImageView = UIImageView();
        self.shakeDownLineImageView.hidden = true;
        self.shakeDownLineImageView.image = UIImage(named: "ic_shake_line_down");
        
        self.shakeDownImageView.addSubview(shakeDownLineImageView);
        
        self.shakeView.addSubview(self.shakeUpImageView);
        self.shakeView.addSubview(self.shakeDownImageView);
        
        self.view.addSubview(self.shakeView);
        self.view.addSubview(self.bottomBar);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if motion == UIEventSubtype.MotionShake {
            AudioServicesPlaySystemSound(self.shakingSoundID);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            self.shaking();
        }
        
    }
    
    func shaking() {
        
        let shakeUpAnimation = CABasicAnimation(keyPath: "transform.translation.y");
        shakeUpAnimation.fromValue = 0;
        shakeUpAnimation.toValue = -animationOffset;
        shakeUpAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        shakeUpAnimation.duration = 0.4;
        shakeUpAnimation.removedOnCompletion = false;
        shakeUpAnimation.fillMode = kCAFillModeBoth;
        shakeUpAnimation.autoreverses = true;
        shakeUpAnimation.delegate = self;
        
        let shakeDownAnimation = CABasicAnimation(keyPath: "transform.translation.y");
        shakeDownAnimation.fromValue = 0;
        shakeDownAnimation.toValue = animationOffset;
        shakeDownAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        shakeDownAnimation.duration = 0.4;
        shakeDownAnimation.removedOnCompletion = false;
        shakeDownAnimation.fillMode = kCAFillModeBoth;
        shakeDownAnimation.autoreverses = true;
        
        self.shakeUpImageView.layer.addAnimation(shakeUpAnimation, forKey: "shakeUpAnimation");
        self.shakeDownImageView.layer.addAnimation(shakeDownAnimation, forKey: "shakeDownAnimation");
    }
    
    override func animationDidStart(anim: CAAnimation) {
        
        self.shakeDownLineImageView.hidden = false;
        self.shakeUpLineImageView.hidden = false;
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        self.shakeDownLineImageView.hidden = true;
        self.shakeUpLineImageView.hidden = true;
        
        NSLog("action", "");
    }
    
}

