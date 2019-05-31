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

    /// Determine if the receiver will respond to user touches in the center of a specified cell.
    ///
    /// - Parameter location: The CLLocationCoordinate2D of the annotation to test.
    /// - Returns: The MKAnnotation that will respond to user touches (if any).
    ///
    func willRespondToUser(at location: CLLocationCoordinate2D) -> MKAnnotation? {
        guard isUserInteractionEnabled else { return nil }
        
        let annotations = self.annotations(in: visibleMapRect).compactMap { $0 as? MKAnnotation }
        
        guard let _ = self.topSuperview else { return nil }
        
        guard let annotation = annotations.first(where: { $0.coordinate.latitude == location.latitude
                                                        && $0.coordinate.longitude == location.longitude }),
              let _ = self.view(for: annotation) else { return nil }
        return annotation
    }

    /// Simulate a user touch a cell in the receiver.
    ///
    /// - Parameter location: The CLLocationCoordinate2D of the annotation.
	///
    func simulateTouch(at location: CLLocationCoordinate2D) {
        if let annotation = self.willRespondToUser(at: location) {
            if !annotationIsSelected(at: location) {
                self.selectAnnotationAndNotify(annotation, animated: false)
            } else {
                self.deselectAnnotation(annotation, animated: false)
            }
        }
    }
}
