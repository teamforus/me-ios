//
//  ScanConfig.swift
//  HSScanCode
//
//  Created by Hanson on 2018/1/31.
//

import Foundation
import AVFoundation
import UIKit

public struct ScanResult {

    public var scanResultString: String? = ""

    public var barCodeType: String? = ""
    
    public init(str: String?, barCodeType: String?) {
        self.scanResultString = str
        self.barCodeType = barCodeType
    }
}

public class ScanWorker: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    /// Video capture device
    lazy var captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    
    /// Capture session
    lazy var captureSession: AVCaptureSession = AVCaptureSession()
    
    /// Video preview layer.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let output = AVCaptureMetadataOutput()
    
    var requireMetadataObjects: [AVMetadataObject.ObjectType]!
    
    /// 存储返回结果
    var arrayResult: [ScanResult] = [];
    
    /// 扫码结果返回block
    var successBlock: ([ScanResult]) -> Void
    
    /// 当前扫码结果是否处理
    var isNeedScanResult: Bool = true
    
    
    // MARK: - Initialization
    
    init(videoPreView: UIView, objType: [AVMetadataObject.ObjectType] = [.qr], cropRect: CGRect = .zero, success: @escaping ( ([ScanResult]) -> Void) ) {

        successBlock = success
        requireMetadataObjects = objType
        super.init()
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            //errorDelegate?.barcodeScanner(self, didReceiveError: error)
            print("AVCaptureDeviceInput(): \(error)")
        }
        
        
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = metadataTypes

        // 显示
        var frame = videoPreView.frame
        frame.origin = CGPoint.zero
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = frame
        videoPreView.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        let scanFrame = videoPreView.frame.width - 44 * 2
        
        let view = UIView(frame: CGRect(x: 44 , y: videoPreView.frame.height / 2.0 - scanFrame / 2.0 - 10, width: scanFrame, height: scanFrame))
        
        videoPreView.bringSubview(toFront: view)
        
        
        if captureDevice.isFocusPointOfInterestSupported && captureDevice.isFocusModeSupported(.continuousAutoFocus) {
            do {
                try captureDevice.lockForConfiguration()
                // 自动对焦
                captureDevice.focusMode = .continuousAutoFocus
                // 拉进镜头
                captureDevice.videoZoomFactor = 1.5
                
                captureDevice.unlockForConfiguration()
            }
            catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
            }
        }
        
        // Notice: 注意 AVCaptureMetadataOutput.rectOfInterest 的值,默认(0.0, 0.0, 1.0, 1.0)（The rectangle's origin is top left. The rectangle's origin is top left and is relative to the coordinate space of the device providing the metadata.）
        // 所以这个 rectOfInterest 应该是 CGRect(Y/预览高度, X/预览宽度, heidth/预览高度, width/预览宽度)
        // 可以利用videoPreviewLayer.metadataOutputRectConverted 方法来便捷转换，但是需在 AVCaptureInputPortFormatDescriptionDidChange通知里设置，不可以在设置 metadataOutput 时接着设置。
        /*
         let scanRect = CGRect(x:cropRect.origin.y/frame.height,
         y:cropRect.origin.x/frame.width,
         width:cropRect.size.height/frame.height,
         height:cropRect.size.width/frame.width)
         output.rectOfInterest = scanRect
         */
        NotificationCenter.default.addObserver(forName: .AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: .current) { (notice) in
            guard cropRect != .zero else { return }
            self.output.rectOfInterest = self.videoPreviewLayer!.metadataOutputRectConverted(fromLayerRect: cropRect)
        }
    }
}


// MARK: - Public Function

extension ScanWorker {
    
    func start() {
        if !captureSession.isRunning {
            isNeedScanResult = true
            captureSession.startRunning()
        }
    }
    func stop() {
        if captureSession.isRunning {
            isNeedScanResult = false
            captureSession.stopRunning()
            NotificationCenter.default.removeObserver(self)
        }
    }
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScanWorker {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        // print(metadataObjects)
        
        if !isNeedScanResult {
            return
        }
        isNeedScanResult = false
        arrayResult.removeAll()

        for metadataObj in metadataObjects {
            if let metadataObj = metadataObj as? AVMetadataMachineReadableCodeObject {
                let codeType = metadataObj.type
                let codeContent = metadataObj.stringValue
                arrayResult.append(ScanResult(str: codeContent, barCodeType: codeType.rawValue))
            }
        }

        if arrayResult.count > 0 {
            stop()
            successBlock(arrayResult)
        } else {
            isNeedScanResult = true
        }
    }
}

fileprivate let metadataTypes = [
    AVMetadataObject.ObjectType.aztec,
    AVMetadataObject.ObjectType.code128,
    AVMetadataObject.ObjectType.code39,
    AVMetadataObject.ObjectType.code39Mod43,
    AVMetadataObject.ObjectType.code93,
    AVMetadataObject.ObjectType.dataMatrix,
    AVMetadataObject.ObjectType.ean13,
    AVMetadataObject.ObjectType.ean8,
    AVMetadataObject.ObjectType.face,
    AVMetadataObject.ObjectType.interleaved2of5,
    AVMetadataObject.ObjectType.itf14,
    AVMetadataObject.ObjectType.pdf417,
    AVMetadataObject.ObjectType.qr,
    AVMetadataObject.ObjectType.upce,
]
