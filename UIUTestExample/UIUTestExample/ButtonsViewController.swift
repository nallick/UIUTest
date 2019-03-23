//
//  ButtonsViewController.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIView
{
	func superview(where predicate: @escaping (UIView) -> Bool) -> UIView? {
		guard let superview = self.superview else { return nil }
		if predicate(superview) { return superview }
		return self.superview.flatMap { $0.superview(where: predicate) }
	}

	func subview(deep: Bool = false, where predicate: @escaping (UIView) -> Bool) -> UIView? {
		if deep {
			for subview in self.subviews {
				if predicate(subview) { return subview }
				let result = subview.subview(deep: true, where: predicate)
				if let _ = result { return result }
			}

			return nil
		}

		return self.subviews.first(where: { predicate($0) })
	}
}
public extension UINavigationController
{
	/// Returns the current back button of the navigation bar (if any).
	///
	var backButton: UIControl? {
		let backView = self.navigationBar.subview(deep: true) {
			guard class_respondsToSelector(type(of: $0), Selector(("isBackButton"))) else { return false }
			let isBack = $0.value(forKey: "isBackButton") as? Bool
			return isBack ?? false
		}

		return backView as? UIControl
	}
}

public class ButtonsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var stepper: UIStepper!

	private var labelValue = 0 {
		didSet {
			self.numberLabel.text = String(labelValue)
		}
	}

    private func countWithGrid() {
        self.stepper.isHidden = true
        self.collectionView.isHidden = false
        if let selectedItem = self.collectionView.indexPathsForSelectedItems?.first?.item {
            self.labelValue = selectedItem + 1
        }
    }

    private func countWithStepper() {
        self.collectionView.isHidden = true
        self.stepper.isHidden = false
        self.labelValue = Int(self.stepper.value)
    }

    @IBAction private func alternateNext(_ sender: Any) {
        guard self.isActiveInNavigationController else { return }
        self.pushSiblingViewController(withIdentifier: "SwitchesViewController", animated: true)
    }

    @IBAction private func selectCountMethod(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
			self.countWithGrid()
		}
		else {
			self.countWithStepper()
		}
    }

    @IBAction private func stepCount(_ sender: UIStepper) {
        self.labelValue = Int(sender.value)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        print("shouldSelectItemAt: \(indexPath.item)")
        return true//(indexPath.item%2 == 0)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let x = self.navigationController?.backButton
		print(x)
		x?.sendActions(for: .touchUpInside)
		let newValue = indexPath.item + 1
		if newValue == self.labelValue {
			self.collectionView.deselectItem(at: indexPath, animated: true)
			self.labelValue = 0
		}
		else {
			self.labelValue = newValue
		}
//        print("didSelectItemAt: \(indexPath.item)")
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print("didDeselectItemAt: \(indexPath.item)")
    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        print("shouldHighlightItemAt: \(indexPath.item)")
        return true
    }

    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        print("didHighlightItemAt: \(indexPath.item)")
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        print("didUnhighlightItemAt: \(indexPath.item)")
    }

//    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
//        print("shouldDeselectItemAt: \(indexPath.item)")
//        return true
//    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let labelString = String(indexPath.item + 1)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
        (cell.backgroundView as? UILabel)?.text = labelString
        (cell.selectedBackgroundView as? UILabel)?.text = labelString
        return cell
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.collectionView.allowsSelection = false
        //self.collectionView.allowsMultipleSelection = true
    }
}
