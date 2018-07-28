//
//  InfoViewController.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public class InfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet private var lightBulbLabel: UILabel!
    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var pickerLabel: UILabel!
	@IBOutlet private var dayOfWeekLabel: UILabel!
	@IBOutlet private var iconLabel: UILabel!

    @IBAction private func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func showLightBulb(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Show Bulb", style: .default, handler: {UIAlertAction in
            self.lightBulbLabel.isHidden = false
        }))

		actionSheet.popoverPresentationController?.sourceView = sender
		actionSheet.popoverPresentationController?.sourceRect = sender.bounds

        self.present(actionSheet, animated: true, completion: nil)
    }

	@IBAction private func dateChanaged(_ sender: UIDatePicker) {
		self.dayOfWeekLabel.text = sender.date.dayOfWeek
	}

	@IBAction private func showHideIcon(_ sender: UIGestureRecognizer) {
		if sender.state == .recognized {
			self.iconLabel.isHidden.toggle()
		}
	}

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerLabel.text = String(row + 1)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.dayOfWeekLabel.text = self.datePicker.date.dayOfWeek
    }
}
