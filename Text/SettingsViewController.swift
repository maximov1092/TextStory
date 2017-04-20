//
//  SettingsViewController.swift
//  Text
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 Maxim. All rights reserved.
//

import UIKit
import StoreKit

protocol SettingsViewControllerDelegate {
    func changeName()
}

class SettingsViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet var userTF: UITextField!
    @IBOutlet var opponentTF: UITextField!
    
    var delegate : SettingsViewControllerDelegate?
    
    let BACKGROUND_PRODUCT_ID = "com.iaptutorial.coins"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var background = UserDefaults.standard.integer(forKey: "background")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTF.text = ConstantsName.userName
        opponentTF.text = ConstantsName.opponentName
        
        // Fetch IAP Products available
        fetchAvailableProducts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func onChangeBackground(_ sender: Any) {
//        purchaseMyProduct(product: iapProducts[0])
    }
    
    @IBAction func onRestore(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @IBAction func onBack(_ sender: Any) {
        
        ConstantsName.userName = userTF.text!
        ConstantsName.opponentName = opponentTF.text!
        
        delegate?.changeName()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            BACKGROUND_PRODUCT_ID
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        nonConsumablePurchaseMade = true
//        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
//        
//        UIAlertView(title: "IAP Tutorial",
//                    message: "You've successfully restored your purchase!",
//                    delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            
            // 1st IAP Product (Consumable) ------------------------------------
            let firstProduct = response.products[0] as SKProduct
            
            // Get its price from iTunes Connect
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = firstProduct.priceLocale
            let price1Str = numberFormatter.string(from: firstProduct.price)
            
            // Show its description
//            consumableLabel.text = firstProduct.localizedDescription + "\nfor just \(price1Str!)"
            // ------------------------------------------------
            
            
            
            // 2nd IAP Product (Non-Consumable) ------------------------------
            let secondProd = response.products[1] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = secondProd.priceLocale
            let price2Str = numberFormatter.string(from: secondProd.price)
            
            // Show its description
//            nonConsumableLabel.text = secondProd.localizedDescription + "\nfor just \(price2Str!)"
            // ------------------------------------
        }
    }

    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            
            // IAP Purchases dsabled on the Device
        } else {
            UIAlertView(title: "IAP Tutorial",
                        message: "Purchases are disabled in your device!",
                        delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // The Consumable product (10 coins) has been purchased -> gain 10 extra coins!
                    if productID == BACKGROUND_PRODUCT_ID {
                        
                        // Add 10 coins and save their total amount
//                        coins += 10
                        UserDefaults.standard.set(background, forKey: "background")
//                        coinsLabel.text = "COINS: \(background)"
                        
                        UIAlertView(title: "IAP Tutorial",
                                    message: "You've successfully bought 10 extra coins!",
                                    delegate: nil,
                                    cancelButtonTitle: "OK").show()
                        
                        
                        
                        // The Non-Consumable product (Premium) has been purchased!
                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    
}
