//
//  Raffel_AppTests.swift
//  Raffel-AppTests
//
//  Created by Tsering Lama on 5/29/21.
//

import XCTest
@testable import Raffel_App

class Raffel_AppTests: XCTestCase {
    
    func testAddingRaffle() {
        let expectation = XCTestExpectation(description: "added raffle")
        
        let createdRaffle = POSTRaffle(name: "XCTestRaffle", secret_token: "xctest")
        
        RaffleAPIClient.postARaffle(createdRaffle: createdRaffle) { result in
            expectation.fulfill()
            
            switch result {
            case .failure(let error):
                XCTFail("Error posting a raffle: \(error.localizedDescription)")
            case .success(let bool):
                XCTAssert(bool)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testaddParticipants() {
        
    }
    
    func testGetAWinner() {
        
    }
}
