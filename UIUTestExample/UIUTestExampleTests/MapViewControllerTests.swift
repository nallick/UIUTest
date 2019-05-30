//
//  MapViewControllerTests.swift
//  UIUTestExampleTests
//
//  Created by Tyler Thompson on 5/28/19.
//  Copyright © 2019 Purgatory Design. All rights reserved.
//

import Foundation
import XCTest
import UIUTestExample
import MapKit
import UIUTest

class MapViewControllerTests: XCTestCase {
    var view: UIView!
    var viewController:MapViewController!
    lazy var mapLoadedExpectation:XCTestExpectation = {
        self.expectation(description: "Map Loading")
    }()
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        UIViewController.initializeTestable()
        viewController = UIViewController.loadFromStoryboard(identifier: "MapViewController") as? MapViewController
        view = viewController.view!
    }
    
    override func tearDown() {
        super.tearDown()
        UIViewController.flushPendingTestArtifacts()
    }
    
    func testSelectingAnnotation() {
        let mapView = view.viewWithAccessibilityIdentifier("mapView") as! MKMapView
        let delegate = mapView.delegate
        
        mapView.delegate = self
        wait(for: [mapLoadedExpectation], timeout: 10)
        mapView.delegate = delegate
        
        mapView.simulateTouch(at: mapView.centerCoordinate)
        let alertController = viewController.mostRecentlyPresentedViewController as? UIAlertController
        XCTAssertNotNil(alertController)
        let alertAction = alertController!.action(withStyle: .default)
        XCTAssertNotNil(alertAction)
        
        alertAction!.simulateTouch()
    }
}

extension MapViewControllerTests: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoadedExpectation.fulfill()
    }
}
