//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Richard on 6/3/16.
//  Copyright © 2016 Richard. All rights reserved.
//

import XCTest
import UIKit
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    //MARK: FoodTracker Tests
    
    //Tests to confirm that the Meal initializer returns when no name or a negative rating is provided
    func testMealInitialization() {
        
        //Success Case
        let potentialItem = Meal(name: "Newest Meal", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        //Failure Cases.
        let noName = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Meal(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
        
    }
}
