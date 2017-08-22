//
//  ViewController.swift
//  tippy
//
//  Created by hajime-u on 8/17/17.
//  Copyright © 2017 hajime-u. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        tipControl.frame.size.height = 54
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        let defaults = UserDefaults.standard
        var isChangedDefaultTip = false
        if (defaults.object(forKey: "defaultTipChanged") != nil) {
            isChangedDefaultTip = defaults.bool(forKey: "defaultTipChanged")
        }

        var defaultTip = 0
        if (defaults.object(forKey: "defaultTip") != nil) {
            defaultTip = defaults.integer(forKey: "defaultTip")
        }
        if (isChangedDefaultTip) {
            tipControl.selectedSegmentIndex = defaultTip
        }

        if ((billField.text?.characters.count)! > 0) {
            calculateTip(billField)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        billField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: Any) {
        let tipPercentages = [0.18, 0.2, 0.25]
        let bill = Double(billField.text!.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip

        tipLabel.text = convertDoubleToStringCurrency(tip)
        totalLabel.text = convertDoubleToStringCurrency(total)
    }

    @IBAction func tapClearBtn(_ sender: Any) {
        billField.text = ""
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var field = ""
        if (billField.text?.characters.count == 0) {
            field = string;
        } else {
            let value = Int(Double(billField.text!.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""))! * 100)
            field = String(value) + string
        }
        
        billField.text = convertDoubleToStringCurrency(Double(field)! / 100.0)
        calculateTip(billField)

        return false
    }
    
    func convertDoubleToStringCurrency(_ price: Double) -> String {
        let currency = NumberFormatter()
        currency.numberStyle = .currency
        currency.locale = Locale(identifier: "en_US")
        return (currency.string(from: price as NSNumber)!)
    }
}

