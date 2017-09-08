//
//  ViewController.swift
//  WalleeExampleSwift
//
//  Created by Tobias Ballat on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

import UIKit
import WalleeSDK

class ViewController: UIViewController, WALPaymentFlowDelegate {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    var successColor: UIColor!
    var failureColor: UIColor!
    var coordinator: WALFlowCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successColor = UIColor(colorLiteralRed: 0.165, green: 0.749, blue: 0.035, alpha: 1.0)
        self.failureColor = UIColor(colorLiteralRed: 0.937, green: 0.314, blue: 0.314, alpha: 1.0)
        self.messageView.isHidden = true
        self.messageLabel.textColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPayment(_ sender: Any) {
        self.startPaymentWithBuilderSyntax()
    }
    
    func startPaymentWithBuilderSyntax() {
        var error: NSError?
        let fetcher = TestCredentialsFetcher()
        let builder = WALFlowConfigurationBuilder(credentialsFetcher: fetcher)
        builder.delegate = self
        
        guard let configuration: WALFlowConfiguration = WALFlowConfiguration.make(with: builder, error: &error) else {
            displayError(error: error)
            return
        }
        
        coordinator = WALFlowCoordinator.paymentFlow(with: configuration)
        coordinator.start()
        
        self.present(coordinator.paymentContainer.viewController(), animated: true, completion: {
            NSLog("display completed")
        })
        
    }
    
    func flowCoordinator(_ coordinator: WALFlowCoordinator, transactionDidSucceed transaction: WALTransaction) {
        DispatchQueue.main.async {
            self.messageView.isHidden = false
            self.messageView.backgroundColor = self.successColor
            self.messageLabel.text = "The Payment was successful."
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, transactionDidFail transaction: WALTransaction!) {
        var error: NSError? = nil
        WALErrorHelper.populate(&error, withFailedTransaction: transaction)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 3 * NSEC_PER_SEC), execute: {
            guard let error = error else {
                return
            }
            self.handleError(error: error)
        })
    }
    
    func handleError(error: Error) {
        print("Transaction ended in Error ", error.localizedDescription)
        DispatchQueue.main.async {
            self.messageView.isHidden = false
            self.messageView.backgroundColor = self.failureColor
            self.messageLabel.text = "The Payment was not completed."
            self.dismiss(animated: true, completion: {
                self.displayError(error: error)
            })
        }
    }
    
    func displayError(error: Error?) {
        guard let error = error else {
            return
        }
        let alert = UIAlertController(title: "Error Code \(error.localizedDescription)", message: error.localizedDescription, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: {
            (_ : UIAlertAction) -> Void in
        })
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Error delegate functions
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, encouteredApiNetworktError error: Error!) {
        self.handleError(error: error)
    }
    
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, encouteredInternalError error: Error!) {
        handleError(error: error)
    }
    
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, encouteredApiClientError error: WALApiClientError!) {
        handleError(error: error)
    }
    
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, encouteredApiServerError error: WALApiServerError!) {
        handleError(error: error)
    }
    
    //MARK: Stub functions for protocol
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, didSelectPaymentMethod paymentMethod: WALPaymentMethodConfiguration!) {    }
    
    func flowCoordinatorWillDisplayPaymentMethodSelection(_ coordinator: WALFlowCoordinator!) {
    }
    
    func flowCoordinatorWillLoadPaymentMethod(_ coordinator: WALFlowCoordinator!) {
    }
    
    func flowCoordinator(_ coordinator: WALFlowCoordinator!, didSelectToken token: WALTokenVersion!) {
    }
    
    
    func flowCoordinatorWillDisplayTokenSelection(_ coordinator: WALFlowCoordinator!) {
    }
    
    
    func flowCoordinatorWillLoadToken(_ coordinator: WALFlowCoordinator!) {
    }
}

