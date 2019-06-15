//
//  MKMapViewSimulation.swift
//
//  Created by Tyler Thompson on 5/29/19.
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import Foundation
import MapKit

@nonobjc public extension MKMapView
{
	/// Allow any pending annotations to load.
	///
	static func loadDataForTesting() {
		RunLoop.current.singlePass()
	}

	/// Determine if the receiver will respond to user touches in the center of the view.
	///
	@objc override var willRespondToUser: Bool {
		let hitView = self.touchWillHitView
		return hitView === self || self.contains(subview: hitView)
	}

	/// Determine if the receiver will respond to user touches at a map coordinate.
	///
	/// - Parameter location: The CLLocationCoordinate2D of the annotation to test.
	/// - Returns: The MKAnnotation that will respond to user touches (if any).
	///
	func willRespondToUser(at location: CLLocationCoordinate2D) -> MKAnnotation? {
		guard let _ = self.topSuperview, self.isUserInteractionEnabled else { return nil }

		let annotations = self.annotations(in: self.visibleMapRect).compactMap { $0 as? MKAnnotation }
		guard let annotation = annotations.first(where: { $0.coordinate.latitude == location.latitude && $0.coordinate.longitude == location.longitude }),
			let _ = self.view(for: annotation)
			else { return nil }
		return annotation
	}

	/// Simulate a user touch in the annotation at a map location in the receiver (if any).
	///
	/// - Parameter location: The CLLocationCoordinate2D of the annotation.
	///
	func simulateTouch(at location: CLLocationCoordinate2D) {
		if let annotation = self.willRespondToUser(at: location) {
			if self.annotationIsSelected(at: location) {
				self.deselectAnnotationAndNotify(annotation, animated: false)
			} else {
				self.selectAnnotationAndNotify(annotation, animated: false)
			}
		}
	}
}
