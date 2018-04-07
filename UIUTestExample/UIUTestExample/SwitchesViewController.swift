//
//  SwitchesViewController.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public class SwitchesViewController: UIViewController
{
    @IBOutlet private var bulbSwitch: UISwitch!
    @IBOutlet private var bulbSlider: UISlider!
    @IBOutlet private var buttonBulbLabel: UILabel!
    @IBOutlet private var switchBulbLabel: UILabel!
    @IBOutlet private var sliderBulbLabel: UILabel!
    @IBOutlet private var sliderAlphaLabel: UILabel!

    @IBAction private func toggleButtonBulb(_ sender: Any) {
        self.buttonBulbLabel.isHidden = !self.buttonBulbLabel.isHidden
    }

    @IBAction private func showSwitchBulb(_ sender: UISwitch) {
        self.switchBulbLabel.isHidden = !sender.isOn
    }

    @IBAction private func setBulbAlpha(_ sender: UISlider) {
        let sliderValue: CGFloat = CGFloat(sender.value)
        self.sliderBulbLabel.alpha = sliderValue
        self.sliderAlphaLabel.text = "\(Int(round(sliderValue*100.0)))%"
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchBulbLabel.isHidden = !self.bulbSwitch.isOn
    }
}
