//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
//    var row : Int = 0
    
    let baseURL = "https://api.coindesk.com/v1/bpi/currentprice/"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "HK$", "Rp", "₪", "₹", "¥", "Mex$", "kr", "$", "zł‚", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row] + ".json"
//        print(finalURL)
        getBTCPriceData(url: finalURL, currencyString: currencyArray[row], currencySymbol: currencySymbol[row])
    }

    
    
    
//
//    //MARK: - Networking
//    /***************************************************************/
//
    func getBTCPriceData(url: String, currencyString: String, currencySymbol: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

//                    print("Sucess! Got the Bitcoin price data")
                    let priceJSON : JSON = JSON(response.result.value!)
//                    print(priceJSON)
                    self.updateBTCPriceData(json: priceJSON, currencyString: currencyString, currencySymbol: currencySymbol)

                } else {
//                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

//
//
//
//
//    //MARK: - JSON Parsing
//    /***************************************************************/
//
    func updateBTCPriceData(json : JSON, currencyString : String, currencySymbol: String) {
        
        if let tempResult = json["bpi"][currencyString]["rate_float"].double {
//        print(tempResult)
            bitcoinPriceLabel.text = "\(currencySymbol) " + String(format: "%.2f", tempResult)
        }
        else {
            bitcoinPriceLabel.text = "Price Unavailable!"
        }
        
    }
    




}

