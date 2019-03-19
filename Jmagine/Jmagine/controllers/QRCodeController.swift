//
//  QRCodeController.swift
//  Jmagine
//
//  Created by mbds on 17/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRCodeDelegate {
    func dataChanged(str: String)
}

class QRCodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: QRCodeDelegate?
    var capt: AVCaptureSession!
    var prev: AVCaptureVideoPreviewLayer!
    
    @objc func backAction(data:String) -> Void {
        dismiss(animated: true, completion: {
            self.delegate?.dataChanged(str:data)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        capt = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("somethin2")
            return
        }
        
        if (capt.canAddInput(videoInput)) {
            capt.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (capt.canAddOutput(metadataOutput)) {
            capt.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        prev = AVCaptureVideoPreviewLayer(session: capt)
        prev.videoGravity = .resizeAspectFill
        prev.frame = view.layer.bounds
        view.layer.addSublayer(prev)
        
        capt.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        capt = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (capt?.isRunning == false) {
            capt.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (capt?.isRunning == true) {
            capt.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        capt.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        self.backAction(data: code)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
