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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true;
        
        let audioPath = NSBundle.mainBundle().pathForResource("shake_sound_male", ofType: ".wav");
        print("audioPath: \(audioPath)");
        let audioUrl = NSURL(fileURLWithPath: audioPath!);
        // 创建一个声音id
        AudioServicesCreateSystemSoundID(audioUrl, &shakingSoundID);
        
        self.setup();
    }
    
    func setup() {
        self.shakeUpImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3.0));
        self.shakeUpImageView.backgroundColor = self.view.backgroundColor;
        self.shakeUpImageView.userInteractionEnabled = false;
        self.shakeUpImageView.image = UIImage(named: "ic_shake_logo_up");
        
        self.shakeUpLineImageView = UIImageView(frame: CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 3, CGRectGetWidth(self.shakeUpImageView.bounds), 10));
        self.shakeUpLineImageView.hidden = true;
        shakeUpLineImageView.image = UIImage(named: "ic_shake_line_up");
        
        self.shakeUpImageView.addSubview(shakeUpLineImageView);
        
        self.shakeDownImageView = UIImageView(frame: CGRectMake(0, CGRectGetMaxY(self.shakeUpImageView.frame), CGRectGetWidth(self.shakeUpImageView.frame), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.shakeUpImageView.frame)));
        self.shakeDownImageView.backgroundColor = self.view.backgroundColor;
        self.shakeDownImageView.userInteractionEnabled = false;
        self.shakeDownImageView.image = UIImage(named: "ic_shake_logo_down");
        
        self.shakeDownLineImageView = UIImageView(frame: CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 3, CGRectGetWidth(self.shakeUpImageView.bounds), 10));
        self.shakeDownLineImageView.hidden = true;
        self.shakeDownLineImageView.image = UIImage(named: "ic_shake_line_down");
        
        self.shakeDownImageView.addSubview(shakeDownLineImageView);
        
        self.view.addSubview(self.shakeUpImageView);
        self.view.addSubview(self.shakeDownImageView);
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

