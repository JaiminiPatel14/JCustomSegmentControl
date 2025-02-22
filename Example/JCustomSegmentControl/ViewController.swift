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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Segment1.addTarget(self, action: #selector(segmentIndexChanged), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc private func segmentIndexChanged(_ sender: JCustomSegmentControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("Selected Segment: \(selectedIndex)")
    }
}

