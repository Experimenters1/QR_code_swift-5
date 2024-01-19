//
//  ViewController.swift
//  QR_code vesion
//
//  Created by Huy Vu on 1/19/24.
//

import UIKit
import SwiftQRCodeScanner



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func scanQRCode(_ sender: Any) {
        //Simple QR Code Scanner
                let scanner = QRCodeScannerController()
                scanner.delegate = self
                self.present(scanner, animated: true, completion: nil)
    }
    
    
    @IBAction func scanQRCodeWithExtraOptions(_ sender: Any) {
        //Configuration for QR Code Scanner
               var configuration = QRScannerConfiguration()
               configuration.cameraImage = UIImage(named: "camera")
               configuration.flashOnImage = UIImage(named: "flash-on")
               configuration.galleryImage = UIImage(named: "photos")
               
               let scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
               scanner.delegate = self
               self.present(scanner, animated: true, completion: nil)
    }
    
}

extension ViewController: QRScannerCodeDelegate {
    func qrScannerDidFail(_ controller: UIViewController, error: QRCodeError) {
        print("error:\(error.localizedDescription)")
    }
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
