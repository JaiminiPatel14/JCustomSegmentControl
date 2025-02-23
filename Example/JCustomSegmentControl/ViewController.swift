//
//  ViewController.swift
//  JCustomSegmentControl
//
//  Created by Jaimini Patel on 02/21/2025.
//  Copyright (c) 2025 Jaimini Patel. All rights reserved.
//

import UIKit
import JCustomSegmentControl

class ViewController: UIViewController {

    @IBOutlet weak var Segment1: JCustomSegmentControl!
    @IBOutlet weak var segment2: JCustomSegmentControl!
    
//    let segmentControl = JCustomSegmentControl(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 45))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        segmentControl.titleSeparatedbyComma = "Edo,Tokyo,New York,San Francisco,London,Sydney"
//        segmentControl.selectedSegmentIndex = 0
//        segmentControl.segmentTextColor = .lightGray
//        segmentControl.selectedSegmentColor = .purple
//        segmentControl.backgroundColor = .white
//        segmentControl.isScrollEnabled = true
//        self.view.addSubview(segmentControl)
//        segmentControl.addTarget(self, action: #selector(segmentIndexChanged(_:)), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func segmentIndexChanged(_ sender: JCustomSegmentControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("Selected Segment: \(selectedIndex)")
    }
}

