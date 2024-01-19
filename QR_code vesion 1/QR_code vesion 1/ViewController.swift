//
//  ViewController.swift
//  QR_code vesion 1
//
//  Created by Huy Vu on 1/19/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
       var previewLayer: AVCaptureVideoPreviewLayer!
    var overlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCamera()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           // Cập nhật kích thước của overlay view
           overlayView.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 200)
       }

    func setupCamera() {
           captureSession = AVCaptureSession()

           guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
           let videoInput: AVCaptureDeviceInput

           do {
               videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
           } catch {
               return
           }

           if (captureSession.canAddInput(videoInput)) {
               captureSession.addInput(videoInput)
           } else {
               failed()
               return
           }

           let metadataOutput = AVCaptureMetadataOutput()

           if (captureSession.canAddOutput(metadataOutput)) {
               captureSession.addOutput(metadataOutput)

               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128, .pdf417, .aztec, .code39]
           } else {
               failed()
               return
           }

           previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           previewLayer.frame = view.layer.bounds
           previewLayer.videoGravity = .resizeAspectFill
           view.layer.addSublayer(previewLayer)

           captureSession.startRunning()
       }
    
    func setupUI() {
            // Thêm overlay view
            overlayView = UIView()
            overlayView.layer.borderColor = UIColor.green.cgColor
            overlayView.layer.borderWidth = 2
            view.addSubview(overlayView)
        }


       func failed() {
           let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning", preferredStyle: .alert)
           present(alert, animated: true)
           captureSession = nil
       }

       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession.stopRunning()

           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
               guard let stringValue = readableObject.stringValue else { return }
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               showAlert(message: stringValue)
           }

           dismiss(animated: true)
       }

       func showAlert(message: String) {
           let alert = UIAlertController(title: "Scanned Result", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               self.captureSession.startRunning()
           }))
           present(alert, animated: true)
       }
}

