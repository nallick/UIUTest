//
//  UIViewControllerTestable.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension UIViewController
{
    private static var hasBeenDismissedKey = 0
    private static var recentPresentedViewControllerKey = 0
    private static var blocksAllSeguesKey = 0
    private static var recentSegueIdentifierKey = 0
    private static var recentSegueValueKey = 0

    public var hasBeenDismissed: Bool {
        get {
            return self.associatedObject(forKey: &UIViewController.hasBeenDismissedKey) ?? false
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.hasBeenDismissedKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var mostRecentlyPresentedViewController: UIViewController? {
        get {
            return self.associatedObject(forKey: &UIViewController.recentPresentedViewControllerKey) ?? nil
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.recentPresentedViewControllerKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var blocksAllSegues: Bool {
        get {
            return self.associatedObject(forKey: &UIViewController.blocksAllSeguesKey) ?? false
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.blocksAllSeguesKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var mostRecentlyPerformedSegueIdentifier: String? {
        get {
            return self.associatedObject(forKey: &UIViewController.recentSegueIdentifierKey)
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.recentSegueIdentifierKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var mostRecentlyPerformedSegue: UIStoryboardSegue? {
        get {
            return self.associatedObject(forKey: &UIViewController.recentSegueValueKey)
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.recentSegueValueKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

	public static func initializeTestable() {
        UIViewController.classInitialized   // reference to ensure initialization is called once and only once
    }

	public static func loadFromStoryboard(identifier: String? = nil, storyboard name: String = "Main", bundle: Bundle = Bundle.main, forNavigation: Bool = false) -> UIViewController? {
        var result: UIViewController?

        let storyboard = UIStoryboard(name: name, bundle: bundle)
        if let identifier = identifier {
            result = storyboard.instantiateViewController(withIdentifier: identifier)
        }
        else {
            guard let initialViewController = storyboard.instantiateInitialViewController() else { return nil }
            result = initialViewController
        }
        if let navigationController = result as? UINavigationController, let topViewController = navigationController.topViewController {
            result = topViewController
        }
        else if forNavigation && result != nil {
            let _ = UINavigationController(rootViewController: result!)
        }

		let window = UIApplication.shared.keyWindow!
		if let rootViewController = window.rootViewController {
			rootViewController.dismiss(animated: false, completion: nil)
			rootViewController.view.removeFromSuperview()
			if let navigationController = rootViewController.navigationController {
				navigationController.view.removeFromSuperview()
				navigationController.viewControllers = []
			}
		}

		window.rootViewController = result
        result?.loadViewIfNeeded()
		result?.view.layoutIfNeeded()

        return result
    }

    @objc func substitute_dismiss(animated flag: Bool, completion: (() -> Swift.Void)?) {
        self.hasBeenDismissed = true
        self.substitute_dismiss(animated: flag, completion: completion)
    }

    @objc func substitute_prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.mostRecentlyPerformedSegue = segue
        self.mostRecentlyPerformedSegueIdentifier = segue.identifier
        if !self.blocksAllSegues {
            self.substitute_prepare(for: segue, sender: sender)
        }
    }

    @objc func substitute_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?) {
        self.mostRecentlyPresentedViewController = viewControllerToPresent
        self.substitute_present(viewControllerToPresent, animated: flag, completion: completion)
    }

    @objc func substitute_performSegue(withIdentifier identifier: String, sender: Any?) {
        if self.blocksAllSegues {
            self.mostRecentlyPerformedSegue = nil
            self.mostRecentlyPerformedSegueIdentifier = identifier
        }
        else {
            self.substitute_performSegue(withIdentifier: identifier, sender: sender)
        }
    }

    @objc func substitute_shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.blocksAllSegues {
            self.mostRecentlyPerformedSegue = nil
            self.mostRecentlyPerformedSegueIdentifier = identifier
            return false
        }

        return true
    }

    private static let classInitialized: () = {
        UIViewController.self.exchangeMethods(#selector(dismiss), #selector(substitute_dismiss))
        UIViewController.self.exchangeMethods(#selector(prepare), #selector(substitute_prepare))
        UIViewController.self.exchangeMethods(#selector(present), #selector(substitute_present))
        UIViewController.self.exchangeMethods(#selector(performSegue), #selector(substitute_performSegue))
        UIViewController.self.exchangeMethods(#selector(shouldPerformSegue), #selector(substitute_shouldPerformSegue))
    }()
}
