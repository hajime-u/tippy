//
//  SettingsViewController.swift
//  tippy
//
//  Created by hajime-u on 8/18/17.
//  Copyright © 2017 hajime-u. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var defaultTipPercentage: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultTipPercentage.frame.size.height = 54
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        var defaultTip = 0
        if (defaults.object(forKey: "defaultTip") != nil) {
            defaultTip = defaults.integer(forKey: "defaultTip")
        }
        defaultTipPercentage.selectedSegmentIndex = defaultTip
        defaults.set(false, forKey: "defaultTipChanged")
        defaults.synchronize()
    }

    @IBAction func tipPercentageChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(defaultTipPercentage.selectedSegmentIndex, forKey: "defaultTip")
        defaults.set(true, forKey: "defaultTipChanged")
        defaults.synchronize()
    }
}
