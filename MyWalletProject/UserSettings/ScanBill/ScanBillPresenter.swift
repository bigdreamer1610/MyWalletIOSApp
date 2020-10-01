//
//  ScanBillPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit
import Vision
import VisionKit

class ScanBillPresenter {
    
    var transaction = Transaction()
    var textIndex = 0
    var isMoney = false

    var viewDelegate: ScanBillViewControllerProtocol?
    var useCase: ScanBillUseCase = ScanBillUseCase()
    
    var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    init() {}
    
    // MARK: - Validate transaction and save transaction to DB
    func saveTransaction(_ transation: Transaction) {
        self.transaction = transation
        if self.transaction.date! == "" {
            self.viewDelegate?.showAlert(false)
        } else {
            self.useCase.saveTransactionToDB(self.transaction)
            self.viewDelegate?.showAlert(true)
        }
    }
    
    // MARK: - Process image with OCR
    func handleImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }

        configureOCR()
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - OCR configuration, extract needed information from the given image
    func configureOCR() {
        self.ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            // MARK: - Extract: 2nd line / Address, 4th line / Date, After "Item(s)" is information about money user spent
            self.textIndex = 0
            self.isMoney = false
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else {
                    return
                }
                
                self.textIndex += 1
                if self.textIndex == 2 {
                    self.transaction.note = topCandidate.string
                }
                if self.textIndex == 4 {
                    self.transaction.date = topCandidate.string
                    self.formatDate()
                }
                if topCandidate.string.contains("Item(s)") {
                    self.isMoney = true
                }
                if self.isMoney {
                    let tempStr = Int(topCandidate.string.replacingOccurrences(of: ",", with: "")) ?? 0
                    if tempStr > 0 {
                        self.transaction.amount = tempStr
                        self.isMoney = false
                    }
                }
            }
            
            // Push data back to view controller to show on UI
            self.viewDelegate?.setupForViews(self.transaction)
        }
        
        self.ocrRequest.recognitionLevel = .accurate
        self.ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        self.ocrRequest.usesLanguageCorrection = true
    }
    
    // MARK: - Formatting date given from bill's image
    func formatDate() {
        var formattedDate = self.transaction.date!
        
        formattedDate = formattedDate.replacingOccurrences(of: "Date: ", with: "")
        formattedDate = formattedDate.replacingOccurrences(of: ",", with: "")
        
        var dateData = formattedDate.split(separator: " ")
        switch dateData[0] {
        case "Jan":
            dateData[0] = "01/"
        case "Feb":
            dateData[0] = "02/"
        case "Mar":
            dateData[0] = "03/"
        case "Apr":
            dateData[0] = "04/"
        case "May":
            dateData[0] = "05/"
        case "Jun":
            dateData[0] = "06/"
        case "Jul":
            dateData[0] = "07/"
        case "Aug":
            dateData[0] = "08/"
        case "Sep":
            dateData[0] = "09/"
        case "Oct":
            dateData[0] = "10/"
        case "Nov":
            dateData[0] = "11/"
        case "Dec":
            dateData[0] = "12/"
        default:
            return
        }
        
        formattedDate = ""
        if dateData[1].count == 1 {
            formattedDate += "0" + dateData[1] + "/"
        } else {
            formattedDate += dateData[1] + "/"
        }
        formattedDate += dateData[0]
        formattedDate += dateData[2]
        
        self.transaction.date = formattedDate
    }
}

