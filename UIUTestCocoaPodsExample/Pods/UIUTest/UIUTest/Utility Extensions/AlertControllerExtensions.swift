//
//  AlertControllerExtensions.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIAlertController
{
    public func action(withTitle title: String) -> UIAlertAction? {
        guard let index = self.actions.index(where: {$0.title == title}) else { return nil }
        return self.actions[index]
    }

    public func action(withStyle style: UIAlertActionStyle) -> UIAlertAction? {
        guard let index = self.actions.index(where: {$0.style == style}) else { return nil }
        return self.actions[index]
    }
}
