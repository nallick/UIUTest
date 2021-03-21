//
//  UIViewControllerTestable.swift
//
//  Copyright © 2017-2020 Purgatory Design. Licensed under the MIT License.
//

import UIKit

@nonobjc public extension UIViewController
{
	typealias FinalizePreparationForSegue = (UIStoryboardSegue, Any?) -> Void

	/// The associated object keys for testable extensions.
	///
    private static var hasBeenDismissedKey = 0
    private static var recentPresentedViewControllerKey = 0
    private static var blocksAllSeguesKey = 0
    private static var recentSegueIdentifierKey = 0
	private static var recentSegueValueKey = 0
	private static var finalizePreparationForSegueKey = 0

	/// Returns true if the receiver has been dismissed; false otherwise.
	///
    var hasBeenDismissed: Bool {
        get {
            return self.associatedObject(forKey: &UIViewController.hasBeenDismissedKey) == true
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.hasBeenDismissedKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

	/// Returns the view controller most recently presented by the receiver (if any).
	///
    var mostRecentlyPresentedViewController: UIViewController? {
        get {
            return self.associatedObject(forKey: &UIViewController.recentPresentedViewControllerKey) ?? nil
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.recentPresentedViewControllerKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

	/// Specifies if the receiver blocks the performance of all segues.
	///
    var blocksAllSegues: Bool {
        get {
            return self.associatedObject(forKey: &UIViewController.blocksAllSeguesKey) == true
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.blocksAllSeguesKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

	/// Returns the identifier of the receiver's most recently performed segue (if any).
	///
    var mostRecentlyPerformedSegueIdentifier: String? {
        get {
            return self.associatedObject(forKey: &UIViewController.recentSegueIdentifierKey)
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.recentSegueIdentifierKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

	/// Returns the receiver's most recently performed segue (if any).
	///
    var mostRecentlyPerformedSegue: UIStoryboardSegue? {
        get {
            return self.associatedObject(forKey: &UIViewController.recentSegueValueKey)
        }
        set {
            self.setAssociatedObject(newValue, forKey: &UIViewController.recentSegueValueKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

	/// Returns the receiver's segue preparation finalization closure (if any).
	///
	/// - Note: This closure will be called immediately after prepare(for:sender).
	///			For example, use this to prevent unwanted live activity in the segue's destination view controller.
	///
	var finalizePreparationForSegue: FinalizePreparationForSegue? {
		get {
			let boxedClosure: FinalizePreparationForSegueBox? = self.associatedObject(forKey: &UIViewController.finalizePreparationForSegueKey)
			return boxedClosure?.closure
		}
		set {
			if let closure = newValue {
				let boxedClosure = FinalizePreparationForSegueBox(closure)
				self.setAssociatedObject(boxedClosure, forKey: &UIViewController.finalizePreparationForSegueKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			} else {
				self.removeAssociatedObject(forKey: &UIViewController.finalizePreparationForSegueKey)
			}
		}
	}

    /// Loads the receiver for testing.
    ///
    /// - Parameters:
    ///   - forNavigation: Specifies if the receiver is to be embedded in a navigation controller.
    ///   - configure: An optional configuration closure called before UIViewController.viewDidLoad().
    /// - Returns: The receiver, or nil if the receiver doesn't conform to the requested type.
    ///
    @discardableResult func loadForTesting<T>(forNavigation: Bool = false, configure: ((T) -> Void)? = nil) -> T? where T: UIViewController {
        guard let result = self as? T else { return nil }

        if forNavigation {
            _ = UINavigationController(rootViewController: self)
        }

        let window = UIApplication.shared.keyWindow
        window?.removeViewsFromRootViewController()

        configure?(result)
        window?.rootViewController = result
        result.loadViewIfNeeded()
        result.view.layoutIfNeeded()

        if forNavigation {
            result.viewWillAppear(false)
            result.viewDidAppear(false)
        }

        CATransaction.flush()   // flush pending CoreAnimation operations to display the new view controller

        return result
    }

    /// Called via the Obj-C runtime when this module is loaded to initialize the testable extensions of UIViewController.
    ///
    @objc override class func initializeTestableFromObjC() {
        UIViewController.initializeTestable()
    }

    /// Initialize the testable extensions of UIViewController.
	///
	/// - Note: Called automatically during module load, or call this during test setup to use these extensions.
	///
   static func initializeTestable() {
        UIViewController.classInitialized   // reference to ensure initialization is called once and only once
    }

	/// Cleanup remaining artifacts of the testable extensions of UIViewController.
	///
	/// - Note: Call this during test tear down when using these extensions.
	///
    static func flushPendingTestArtifacts() {
        let window = UIApplication.shared.keyWindow
        window?.removeViewsFromRootViewController()
        window?.rootViewController = nil
        RunLoop.current.singlePass()
        RunLoop.current.singlePass()
    }

	/// Returns a view controller loaded directly from a storyboard for testing.
	///
	/// - Parameters:
	///   - identifier: The view controller's storyboard identifier.
	///   - name: The storyboard's name.
	///   - bundle: The storyboard's bundle.
	///   - forNavigation: Specifies if the loaded view controller is to be embedded in a navigation controller.
	///   - configure: An optional configuration closure called before UIViewController.viewDidLoad().
	/// - Returns: The loaded view controller.
	///
    static func loadFromStoryboard<T>(identifier: String? = nil, storyboard name: String = "Main", bundle: Bundle = Bundle.main, forNavigation: Bool = false, configure: ((T) -> Void)? = nil) -> T? where T: UIViewController {
        return self.privateLoad(identifier: identifier, storyboard: name, bundle: bundle, forNavigation: forNavigation, creator: nil, configure: configure)
    }

    /// Returns a view controller loaded directly from a storyboard for testing.
    ///
    /// - Parameters:
    ///   - identifier: The view controller's storyboard identifier.
    ///   - name: The storyboard's name.
    ///   - bundle: The storyboard's bundle.
    ///   - forNavigation: Specifies if the loaded view controller is to be embedded in a navigation controller.
    ///   - creator: An optional creation closure called during instantiation.
    /// - Returns: The loaded view controller.
    ///
    @available(iOS 13, *)
    static func createFromStoryboard<T>(identifier: String? = nil, storyboard name: String = "Main", bundle: Bundle = Bundle.main, forNavigation: Bool = false, creator: ((NSCoder) -> T?)? = nil) -> T? where T: UIViewController {
        return self.privateLoad(identifier: identifier, storyboard: name, bundle: bundle, forNavigation: forNavigation, creator: creator, configure: nil)
    }

    /// An alternate method to be swizzled with UIViewController.dismiss().
    ///
    @objc func substitute_dismiss(animated flag: Bool, completion: (() -> Swift.Void)?) {
        self.hasBeenDismissed = true
        self.substitute_dismiss(animated: flag, completion: completion)
    }

	/// An alternate method to be swizzled with UIViewController.prepare().
	///
    @objc func substitute_prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.mostRecentlyPerformedSegue = segue
        self.mostRecentlyPerformedSegueIdentifier = segue.identifier
        if !self.blocksAllSegues { self.substitute_prepare(for: segue, sender: sender) }
		self.finalizePreparationForSegue?(segue, sender)
    }

	/// An alternate method to be swizzled with UIViewController.present().
	///
    @objc func substitute_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?) {
        self.mostRecentlyPresentedViewController = viewControllerToPresent
        self.substitute_present(viewControllerToPresent, animated: flag, completion: completion)
    }

	/// An alternate method to be swizzled with UIViewController.performSegue().
	///
    @objc func substitute_performSegue(withIdentifier identifier: String, sender: Any?) {
        if self.blocksAllSegues {
            self.mostRecentlyPerformedSegue = nil
            self.mostRecentlyPerformedSegueIdentifier = identifier
        }
        else {
            self.substitute_performSegue(withIdentifier: identifier, sender: sender)
        }
    }

	/// An alternate method to be swizzled with UIViewController.shouldPerformSegue().
	///
    @objc func substitute_shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.blocksAllSegues {
            self.mostRecentlyPerformedSegue = nil
            self.mostRecentlyPerformedSegueIdentifier = identifier
            return false
        }

        return true
    }

    /// Returns a view controller loaded directly from a storyboard for testing.
    ///
    /// - Parameters:
    ///   - identifier: The view controller's storyboard identifier.
    ///   - name: The storyboard's name.
    ///   - bundle: The storyboard's bundle.
    ///   - forNavigation: Specifies if the loaded view controller is to be embedded in a navigation controller.
    ///   - creator: An optional creation closure called during instantiation (requries iOS 13 or later).
    ///   - configure: An optional configuration closure called before UIViewController.viewDidLoad().
    /// - Returns: The loaded view controller.
    ///
    private static func privateLoad<T>(identifier: String?, storyboard name: String, bundle: Bundle, forNavigation: Bool, creator: ((NSCoder) -> T?)?, configure: ((T) -> Void)?) -> T? where T: UIViewController {
        var viewController: UIViewController?
        var createNavigationController = false

        let storyboard = UIStoryboard(name: name, bundle: bundle)
        if let identifier = identifier {
            if #available(iOS 13, *), let creator = creator {
                viewController = storyboard.instantiateViewController(identifier: identifier, creator: creator)
            } else {
                viewController = storyboard.instantiateViewController(withIdentifier: identifier)
            }
        }
        else {
            if #available(iOS 13, *), let creator = creator {
                viewController = storyboard.instantiateInitialViewController(creator: creator)
            } else {
                viewController = storyboard.instantiateInitialViewController()
            }
            guard let _ = viewController else { return nil }
        }
        if let navigationController = viewController as? UINavigationController, let topViewController = navigationController.topViewController {
            viewController = topViewController
        }
        else {
            createNavigationController = forNavigation
        }

        return viewController?.loadForTesting(forNavigation: createNavigationController, configure: configure)
    }

	/// Initialize the testable extensions of UIViewController. This singleton is only executed once.
	///
    private static let classInitialized: Void = {
        UIViewController.self.exchangeMethods(#selector(dismiss), #selector(substitute_dismiss))
        UIViewController.self.exchangeMethods(#selector(prepare), #selector(substitute_prepare))
        UIViewController.self.exchangeMethods(#selector(present), #selector(substitute_present))
        UIViewController.self.exchangeMethods(#selector(performSegue), #selector(substitute_performSegue))
        UIViewController.self.exchangeMethods(#selector(shouldPerformSegue), #selector(substitute_shouldPerformSegue))
    }()

	private class FinalizePreparationForSegueBox {
		let closure: FinalizePreparationForSegue
		init(_ closure: @escaping FinalizePreparationForSegue) { self.closure = closure }
	}
}
