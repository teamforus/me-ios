//
//  HSScanViewController.swift
//  HSScanCode
//
//  Created by Hanson on 2018/1/30.
//

import UIKit
import AVFoundation

public protocol HSScanViewControllerDelegate: class {
    func scanFinished(scanResult: ScanResult, error: String?)
}

public class HSScanViewController: UIViewController {
    
    /// 扫码功能配置
    public var scanWorker: ScanWorker!
    
    /// 识别码的类型
    public var scanCodeTypes: [AVMetadataObject.ObjectType]! = [.qr]
    
    /// 扫码页面属性
    public var scanStyle: HSDefaultScanViewStyle!

    public weak var delegate: HSScanViewControllerDelegate?
    
    // MARK: - Initialization
    
    public init(scanStyle: HSDefaultScanViewStyle = HSDefaultScanViewStyle(), scanCodeTypes: [AVMetadataObject.ObjectType] = [.qr]) {
        super.init(nibName: nil, bundle: nil)
        
        self.scanStyle = scanStyle
        self.scanCodeTypes = scanCodeTypes
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        ScanPermission.authorizeCamera { [weak self] (isGranted) in
            guard let strongSelf = self else { return }
            if isGranted {
                strongSelf.startScan()
                
            } else {
                
            }
        }
    }
}


// MARK: - Function

extension HSScanViewController {
    
    func startScan() {
        let defaultScanView = HSDefaultScanView(frame: self.view.frame)
        
        scanWorker = ScanWorker(videoPreView: self.view, objType: scanCodeTypes, cropRect: defaultScanView.scanRect, success: { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.handleScanResult(results: result)
        })
        self.view.addSubview(defaultScanView)
        scanWorker.start()
    }
    
    func handleScanResult(results: [ScanResult]) {
        self.navigationController?.popViewController(animated: true)
        let result: ScanResult = results[0]

        delegate?.scanFinished(scanResult: result, error: nil)
    }

}
