//
//  ViewController.swift
//  MultiThreading
//
//  Created by Alireza Moradi on 2/20/1399 AP.
//  Copyright © 1399 Alireza Moradi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var queue = DispatchQueue(label: "single")
    let group = DispatchGroup()
    var start = CFAbsoluteTimeGetCurrent()
    var end = CFAbsoluteTimeGetCurrent()
    
    @IBOutlet var lblsTitle: [UILabel]!
    @IBOutlet var txtFieldsCount: [UITextField]!
    @IBOutlet weak var btnsStart: UIButton!
    @IBOutlet var lblsElapsed: [UILabel]!
    @IBOutlet var switchs: [UISwitch]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func multiLoop(count: Int, tag:Int) {
        start = CACurrentMediaTime()
        DispatchQueue(label: "queue1").async(group: group) {
            for i in 0..<count {
                print("\(i) 😍")
            }
        }
        DispatchQueue(label: "queue2", qos: .userInteractive).async(group: group)  {
            for i in 0..<count {
                print("\(i) 😘")
            }
        }
        group.notify(queue: .main) {
            self.end = CACurrentMediaTime()
            self.lblsElapsed[tag].text = "\(self.end - self.start)"
        }
    }
    func otherMultiLoop(count: Int, tag:Int) {
        queue = DispatchQueue(label: "Multi", attributes: .concurrent)
        start = CACurrentMediaTime()
        queue.async(group: group) {
            for i in 0..<count {
                print("\(i) 😍")
            }
        }
        queue.async(group: group) {
            for i in 0..<count {
                print("\(i) 😘")
            }
        }
        group.notify(queue: .main) {
            self.end = CACurrentMediaTime()
            self.lblsElapsed[tag].text = "\(self.end - self.start)"
        }
    }
    func singleLoop(count: Int, tag:Int) {
        start = CACurrentMediaTime()
        DispatchQueue(label: "queue1", qos: .userInteractive).sync {
            for i in 0..<count {
                print("\(i) 😍")
            }
        }
        DispatchQueue(label: "queue2", qos: .background).sync {
            for i in 0..<count {
                print("\(i) 😘")
            }
        }
        self.end = CACurrentMediaTime()
        self.lblsElapsed[tag].text = "\(self.end - self.start)"
    }
    func otherSingleLoop(count: Int, tag:Int) {
        queue = DispatchQueue(label: "single")
        start = CACurrentMediaTime()
        queue.async(group: group) {
            for i in 0..<count {
                print("\(i) 😍")
            }
        }
        queue.async(group: group) {
            for i in 0..<count {
                print("\(i) 😘")
            }
        }
        group.notify(queue: .main) {
            self.end = CACurrentMediaTime()
            self.lblsElapsed[tag].text = "\(self.end - self.start)"
        }
    }
    func endKeyboard() {
        view.endEditing(true)
    }
    @IBAction func switchChange(_ sender: UISwitch) {
        lblsTitle[sender.tag].text = sender.isOn ? "Multi" : "Single"
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        endKeyboard()
        let count:Int = Int(txtFieldsCount[sender.tag].text ?? "") ?? 0
        if switchs[sender.tag].isOn {
            multiLoop(count: count, tag: sender.tag) //otherMultiLoop(count: count)
        } else {
            singleLoop(count: count, tag: sender.tag) //singleLoop(count: count)
        }
        lblsElapsed[sender.tag].text = "\(self.end - self.start)"
    }
}

