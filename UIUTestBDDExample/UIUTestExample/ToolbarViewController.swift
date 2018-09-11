//
//  ToolbarViewController.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public class ToolbarViewController: UIViewController
{
    @IBOutlet private var toolbar: UIToolbar!
    @IBOutlet private var toolLabel: UILabel!

    @IBAction private func showSelectedTool(_ sender: UIBarButtonItem) {
        if let labelText = sender.title, labelText.count == 1 {
            self.toolLabel.text = labelText
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let labelLayer = self.toolLabel.layer
        labelLayer.shadowColor = UIColor.black.cgColor
        labelLayer.shadowOffset = CGSize(width: 6.0, height: 6.0)
        labelLayer.shadowOpacity = 0.5
        labelLayer.shadowRadius = 18.0

        if let count = self.toolbar.items?.count, count > 1, let toolbarItem = self.toolbar.items?[1] {
            self.showSelectedTool(toolbarItem)
        }
    }
}
