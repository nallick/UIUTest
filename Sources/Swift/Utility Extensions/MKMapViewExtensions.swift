//
//  MKMapViewExtensions.swift
//
//  Created by Tyler Thompson on 5/29/19.
//  Copyright © 2019 Purgatory Design. Licensed under the MIT License.
//

import Foundation
import MapKit

@nonobjc public extension MKMapView
{
    /// Specifies if the receiver currently allows selection.
    ///
    var currentlyAllowsSelection: Bool {
        return self.isUserInteractionEnabled
    }
    
    /// Determine if a selected annotation exists at a map location.
    ///
    /// - Parameter location: The CLLocationCoordinate2D of the annotation to test.
    /// - Returns: true if the annotation exists and is selected; false otherwise.
    ///
    func annotationIsSelected(at location: CLLocationCoordinate2D) -> Bool {
        return self.selectedAnnotations.contains { $0.coordinate.latitude == location.latitude && $0.coordinate.longitude == location.longitude }
    }
    
    /// Select an annotation and perform the delegate operations as if the selection was performed interactively rather than programatically.
    ///
    /// - Parameters:
    ///   - annotation: The annotation to select.
    ///   - animated: Specifies if selection animations will be used.
    ///
    /// - Note:
    ///        This mirrors MKMapView.selectAnnotation(_ annotation: MKAnnotation?, animated: Bool)
    ///
    func selectAnnotationAndNotify(_ annotation: MKAnnotation, animated: Bool) {
        guard let view = self.view(for: annotation) else { return }
        self.selectAnnotation(annotation, animated: animated)
        self.delegate?.mapView?(self, didSelect: view)
    }

    /// Deselect an annotation and perform the delegate operations as if the selection was performed interactively rather than programatically.
    ///
    /// - Parameters:
    ///   - annotation: The annotation to deselect.
    ///   - animated: Specifies if selection animations will be used.
    ///
    /// - Note:
    ///        This mirrors MKMapView.deselectAnnotation(_ annotation: MKAnnotation?, animated: Bool)
    ///
    func deselectAnnotationAndNotify(_ annotation: MKAnnotation, animated: Bool) {
        guard let view = self.view(for: annotation) else { return }
        self.deselectAnnotation(annotation, animated: animated)
        self.delegate?.mapView?(self, didDeselect: view)
    }
}
