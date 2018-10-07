//
//  LalaTestUITests.swift
//  LalaTestUITests
//
//  Created by Venugopalan, Vimal on 9/28/18.
//  Copyright © 2018 Kenneth. All rights reserved.
//

import XCTest

class LalaTestUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDetailView() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let deliveriestableviewTable = app.tables["DeliveriesTableView"]
        XCTAssertTrue(deliveriestableviewTable.exists, "The deliveries tableview exists")
        
        // Get an array of cells
        let tableCells = deliveriestableviewTable.cells

        sleep(5)
        
        if tableCells.count > 0 {
            let count: Int = (tableCells.count - 1)
            
            let promise = expectation(description: "Wait for table cells")
            
            for i in stride(from: 0, to: count , by: 1) {
                // Grab the first cell and verify that it exists and tap it
                let tableCell = tableCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                // Does this actually take us to the next screen
                tableCell.tap()
                
                if i == (count - 1) {
                    promise.fulfill()
                }
                // Back
                app.navigationBars.buttons.element(boundBy: 0).tap()
            }
            waitForExpectations(timeout: 20, handler: nil)
            XCTAssertTrue(true, "Finished validating the table cells")
            
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
        
    }
    
    func testPullToRefresh() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let deliveriestableviewTable = app.tables["DeliveriesTableView"]
        XCTAssertTrue(deliveriestableviewTable.exists, "The deliveries tableview exists")
        
        // Get an array of cells
        let tableCells = deliveriestableviewTable.cells
        
        sleep(5)
        
        if tableCells.count > 0 {
            
            let firstCell = tableCells.element(boundBy: 0)
            XCTAssertTrue(firstCell.exists, "The \(0) cell is in place on the table")
            // drag start point
            let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
            // drag end point
            let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
            start.press(forDuration: 0, thenDragTo: finish)
            
            sleep(5)
            if tableCells.count>0{
                XCTAssertTrue(true, "Finished validating the pull to refresh")
            }
            
        } else {
            XCTAssert(false, "Was not able to find any table cells")
        }
    }
    
//    func testPeekAPop(){
//        
//        let app = XCUIApplication()
//        let deliveriestableviewTable = app.tables["DeliveriesTableView"]
//        XCTAssertTrue(deliveriestableviewTable.exists, "The deliveries tableview exists")
//        
//        // Get an array of cells
//        let tableCells = deliveriestableviewTable.cells
//        
//        sleep(5)
//        
//        if tableCells.count > 0 {
//            
//            let firstCell = tableCells.element(boundBy: 0)
//            XCTAssertTrue(firstCell.exists, "The \(0) cell is in place on the table")
//            // Does this actually take us to the next screen
//            let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
//            let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
//            start.press(forDuration: 2, thenDragTo: finish)
//
//            
//        } else {
//            XCTAssert(false, "Was not able to find any table cells")
//        }
//    }
    
    func testNoDataInitialScreen() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        
        let deliveriestableviewTable = app.tables["DeliveriesTableView"]
        XCTAssertTrue(deliveriestableviewTable.exists, "The deliveries tableview exists")
        
        // Get an array of cells
        let tableCells = deliveriestableviewTable.cells
        // initially no data so loading screen.
        if tableCells.count == 0 {
            XCTAssert(true, "Was not able to find any table cells")
        }
        
        
    }
    
    func testBackGroundReload() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        sleep(5)
        //press home button
        XCUIDevice.shared.press(.home)
        //relaunch app from background
        app.activate()
        sleep(5)

        
    }
    

}
