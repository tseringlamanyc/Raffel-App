//
//  Raffel_AppTests.swift
//  Raffel-AppTests
//
//  Created by Tsering Lama on 5/29/21.
//

import XCTest
@testable import Raffel_App

class Raffel_AppTests: XCTestCase {
    
//        func testAddingRaffle() {
//            let expectation = XCTestExpectation(description: "added raffle")
//
//            let createdRaffle = Raffle(id: nil, name: "Listener Please", created_at: nil, raffled_at: nil, winner_id: nil, secret_token: "lol123")
//
//            RaffleAPIClient.postARaffle(createdRaffle: createdRaffle) { result in
//                expectation.fulfill()
//
//                switch result {
//                case .failure(let error):
//                    XCTFail("Error posting a raffle: \(error.localizedDescription)")
//                case .success(let bool):
//                    XCTAssert(bool)
//                }
//            }
//
//            wait(for: [expectation], timeout: 3.0)
//        }
    
    func testRaffleId()  {
        
        let expectation = 53
        let exp = XCTestExpectation(description: "id found")
        
        RaffleAPIClient.getAllRaffle { result in
            switch result {
            case .failure(let error):
                XCTFail("Error getting raffle: \(error.localizedDescription)")
            case .success(let allRaffle):
                XCTAssertEqual(allRaffle.count, expectation)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
    }
    
    func testaddParticipants() {
        let expectation = XCTestExpectation(description: "added participant success")
        
        let participant = Participant(id: nil, raffle_id: 88, firstname: "Huni", lastname: "Huni", email: "huni@gmail.com", phone: nil, registered_at: nil)
        
        RaffleAPIClient.postAParticipant(id: participant.raffle_id, participant: participant) { result in
            expectation.fulfill()
            
            switch result {
            case .failure(let error):
                XCTFail("Error posting a participant: \(error.localizedDescription)")
            case .success(let bool):
                XCTAssert(bool)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testaddParticipants2() {
        let expectation = XCTestExpectation(description: "added participant success")
        
        let participant = Participant(id: nil, raffle_id: 88, firstname: "Goat", lastname: "Faker", email: "faker¨@gmail.com", phone: nil, registered_at: nil)
        
        RaffleAPIClient.postAParticipant(id: participant.raffle_id, participant: participant) { result in
            expectation.fulfill()
            
            switch result {
            case .failure(let error):
                XCTFail("Error posting a participant: \(error.localizedDescription)")
            case .success(let bool):
                XCTAssert(bool)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testRequestAWinner() {
        let expectation = XCTestExpectation(description: "winner found")
        
        RaffleAPIClient.requestAWinner(token: "lol123", raffleId: 88) { result in
            expectation.fulfill()
            
            switch result {
            case .failure(let error):
                XCTFail("Error putting a winner: \(error)")
            case .success(_):
                XCTAssert(true)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetWinner() {
        let expectation = XCTestExpectation(description: "able to get winner information")
        let expectedWinnerId = 107
        
        RaffleAPIClient.getAWinner(id: 78) { result in
            switch result {
            case .failure(let error):
                XCTFail("Error getting a winner:\(error)")
            case .success(let aWinner):
                XCTAssertEqual(expectedWinnerId, aWinner.id)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetParticipants() {
        let expectation = XCTestExpectation(description: "found participants")
        let expParticipantCount = 2
        
        RaffleAPIClient.getAllParticipants(id: 88) { (result) in
            switch result {
            case .failure(let error):
                XCTFail("Error getting participants: \(error)")
            case .success(let participants):
                XCTAssertEqual(expParticipantCount, participants.count)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)
    }
}
