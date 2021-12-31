//
//  Swift_Request_Main_View_UITests.swift
//  Swift RequestUITests
//
//  Created by Jonathan Dowdell on 12/30/21.
//

import XCTest
import Swift_Request

class Swift_Request_Main_View_UITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        self.app = XCUIApplication()
        self.app.launch()

    }
    
    fileprivate func addProject(iteration: Int = 1, addRequest: Bool = false) {
        let composeProject = self.app.buttons["composeProject"]
        let projectNameTextField = self.app.textFields["projectNameTextField"]
        let versionTextField = self.app.textFields["versionTextField"]
        let projectSaveBtn = self.app.buttons["projectSaveBtn"]
        
        composeProject.tap()
        
        projectNameTextField.tap()
        projectNameTextField.typeText("Project #\(iteration)")
        
        versionTextField.tap()
        versionTextField.typeText("Version 1.0")
        
        if addRequest {
            let unAssignedRequests = self.app.tables["addProjectionList"].buttons["unAssignedRequestBtn"]
            if unAssignedRequests.isHittable {
                unAssignedRequests.firstMatch.tap()
            }
        }
        
        projectSaveBtn.tap()
    }
    
    fileprivate func addRequest(iteration: Int = 1, addUrlParam: Bool = false, postMethod: Bool = false) {
        let initialItemCount = self.app.tables["mainSection"].cells.count
        
        let composeRequest = self.app.buttons["composeRequest"]
        composeRequest.tap()
        
        let titleTextField = self.app.textFields["titleTextField"]
        let urlTextField = self.app.textFields["urlTextField"]
        titleTextField.tap()
        titleTextField.typeText("Request #\(iteration)")
        urlTextField.tap()
        urlTextField.typeText("Localhost:3000/request\(iteration)")
        
        if postMethod {
            let tablesQuery = self.app.tables
            let methodTypePicker: XCUIElement = self.app.tables.buttons["methodTypePicker"]
            methodTypePicker.tap()
            tablesQuery.switches["POST"].tap()
        }
        
        if addUrlParam {
            let addUrlParamBtn = self.app.buttons["addUrlParamBtn"]
            addUrlParamBtn.tap()
            
            let paramKeyTextField = self.app.textFields["paramKeyTextField"]
            paramKeyTextField.tap()
            paramKeyTextField.typeText("key")
            
            let paramValueTextField = self.app.textFields["paramValueTextField"]
            paramValueTextField.tap()
            paramValueTextField.typeText("123")
            
            let paramToggleButton = self.app.buttons["paramToggleButton"]
            paramToggleButton.tap()
            paramToggleButton.tap()
        }
        
        let runRequestBtn = self.app.buttons["runRequestBtn"]
        let closeRequestBtn = self.app.buttons["closeRequestBtn"]
        runRequestBtn.tap()
        closeRequestBtn.tap()
        
        XCTAssertEqual(self.app.tables["mainSection"].cells.count, initialItemCount + 1)
    }

    func testAddProject1() throws {
        addProject(addRequest: true)
    }

    func testAddProject2() {
        addProject(iteration: 2, addRequest: false)
    }

    func testAddRequest1() throws {
        addRequest(iteration: 1, addUrlParam: true, postMethod: true)
    }

    func testAddRequest2() throws {
        addRequest(iteration: 2, addUrlParam: true)
    }
    
    func testRemoveHistoryItem() throws {
        let mainSection = self.app.tables["mainSection"].cells
        if mainSection.count > 0 {
            for _ in 0...mainSection.count - 1 {
                mainSection.element(boundBy: 0).swipeLeft()
                mainSection.element(boundBy: 0).buttons["Delete"].tap()
            }
        }
        XCTAssertEqual(mainSection.count, 0)
    }
    
    func testValidState() {
        let mainSection = self.app.tables["mainSection"].cells
        XCTAssertEqual(mainSection.count, 0)
        
    }
    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}

