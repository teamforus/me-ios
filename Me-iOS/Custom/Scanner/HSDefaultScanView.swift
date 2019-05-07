//
//  HSDefaultScanView.swift
//  HSScanCode
//
//  Created by Hanson on 2018/1/31.
//

import UIKit
import AVFoundation

public struct HSDefaultScanViewStyle {
    
    public var scanRectOffsetX: CGFloat = 44
    
    public var scanRectOffsetY: CGFloat = 10
    
    /// 扫码区域线框颜色
    public var scanRetangleLineColor = UIColor.white
    
    /// 扫码区域四个角的颜色
    public var scanRetangleCornerColor = #colorLiteral(red: 0.1878251731, green: 0.3658521771, blue: 0.9840422273, alpha: 1)
    
    /// 扫码区域角线长度
    public var scanRetangleCornerLength: CGFloat = 24
    
    /// 扫码区域角线厚度
    public var scanRetangleCornerThickness: CGFloat = 6
    
    /// 非扫描识别区域的颜色
    public var unRecoginitonAreaColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    public init() {
        
    }
}

protocol HSScanViewProtocol {
    var scanRect: CGRect { get }
}

public class HSDefaultScanView: UIView, HSScanViewProtocol {
    
    var viewStyle = HSDefaultScanViewStyle()
    
    var scanRetangleWH: CGFloat {
        return self.frame.width - viewStyle.scanRectOffsetX * 2
    }
    var scanRectangleTopY: CGFloat {
        return self.frame.height / 2.0 - scanRetangleWH/2.0 - viewStyle.scanRectOffsetY
    }
    var scanRect: CGRect {
        return CGRect(x: viewStyle.scanRectOffsetX, y: scanRectangleTopY, width: scanRetangleWH, height: scanRetangleWH)
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        let label = UILabel.init(frame: CGRect(x: 0, y: 60, width: self.frame.width, height: 46))
        label.text = "Scan QR-code"
        label.textColor = .white
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        label.font = UIFont(name: "GoogleSans-Medium", size: 36)
        
        self.addSubview(label)
        
        let button = UIButton.init(frame: CGRect(x: self.frame.width - 40, y: 50, width: 30, height: 60))
        button.setImage(#imageLiteral(resourceName: "FlashlightOff"), for: .normal)
        button.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        button.addTarget(self, action: #selector(toggleFlash(sender:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    public init(frame: CGRect, style: HSDefaultScanViewStyle) {
        super.init(frame: frame)
        self.viewStyle = style
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        drawDefaultRect(rect)
    }
}

extension HSDefaultScanView {
    
    @objc func toggleFlash(sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
                sender.setImage(#imageLiteral(resourceName: "FlashlightOff"), for: .normal)
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    sender.setImage(#imageLiteral(resourceName: "FlashlightOn"), for: .normal)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func drawDefaultRect(_ rect: CGRect) {
        let scanRectangleOffsetX = viewStyle.scanRectOffsetX
        
        let scanRectangleBottomY = scanRectangleTopY + scanRetangleWH
        let scanRectangleRightX = self.frame.width - scanRectangleOffsetX
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(viewStyle.unRecoginitonAreaColor.cgColor)
        // top area of scan rectangle
        var rect = CGRect(x: 0, y: 0, width: self.frame.width, height: scanRectangleTopY)
        context.fill(rect)
        // left area of scan rectangle
        rect = CGRect(x: 0, y: scanRectangleTopY, width: scanRectangleOffsetX, height: scanRetangleWH)
        context.fill(rect)
        // right area of scan rectangle
        rect = CGRect(x: scanRectangleRightX, y: scanRectangleTopY, width: scanRectangleOffsetX, height: scanRetangleWH)
        context.fill(rect)
        // bottom area of scan rectangle
        rect = CGRect(x: 0, y: scanRectangleBottomY, width: self.frame.width, height: self.frame.height - scanRectangleBottomY)
        context.fill(rect)
        
        context.strokePath()
        
        // Scan Rectangle
        context.setStrokeColor(viewStyle.scanRetangleLineColor.cgColor)
        context.setLineWidth(1)
        // white line
//        context.addRect(CGRect(x: scanRectangleOffsetX, y: scanRectangleTopY, width: scanRetangleWH, height: scanRetangleWH))
        context.strokePath()

        // 相框角的宽度和高度
        let wAngle = viewStyle.scanRetangleCornerLength
        let hAngle = viewStyle.scanRetangleCornerLength
        
        //4个角的 线的宽度
        let linewidthAngle = viewStyle.scanRetangleCornerThickness
        
        context.setStrokeColor(viewStyle.scanRetangleCornerColor.cgColor);
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setLineWidth(linewidthAngle)
        
        let leftX = scanRectangleOffsetX
        let topY = scanRectangleTopY
        let rightX = scanRectangleRightX
        let bottomY = scanRectangleBottomY
        
        let imageViewSquare1 = UIImageView(frame: CGRect(x: leftX-linewidthAngle/2 + 3, y: topY, width: 26, height: 26))
        imageViewSquare1.image = UIImage(named: "4")
        self.addSubview(imageViewSquare1)
        
        let imageViewSquare2 = UIImageView(frame: CGRect(x: leftX-linewidthAngle/2 + 3, y: bottomY - hAngle - 2, width: 26, height: 26))
        imageViewSquare2.image = UIImage(named: "1-1")
        self.addSubview(imageViewSquare2)
        
        let imageViewSquare3 = UIImageView(frame: CGRect(x: rightX - wAngle - 2, y: topY, width: 26, height: 26))
        imageViewSquare3.image = UIImage(named: "3")
        self.addSubview(imageViewSquare3)
        
        let imageViewSquare4 = UIImageView(frame: CGRect(x: rightX - wAngle - 2, y: bottomY - hAngle - 2, width: 26, height: 26))
        imageViewSquare4.image = UIImage(named: "2")
        self.addSubview(imageViewSquare4)
        //左上角水平线
//        context.move(to: CGPoint(x: leftX-linewidthAngle/2, y: topY))
//        context.addLine(to: CGPoint(x: leftX + wAngle, y: topY))
//        
//        // 左上角垂直线
//        context.move(to: CGPoint(x: leftX, y: topY-linewidthAngle/2))
//        context.addLine(to: CGPoint(x: leftX, y: topY+hAngle))
//        
//        // 左下角水平线
//        context.move(to: CGPoint(x: leftX-linewidthAngle/2, y: bottomY))
//        context.addLine(to: CGPoint(x: leftX + wAngle, y: bottomY))
//        
//        // 左下角垂直线
//        context.move(to: CGPoint(x: leftX, y: bottomY+linewidthAngle/2))
//        context.addLine(to: CGPoint(x: leftX, y: bottomY - hAngle))
//        
//        // 右上角水平线
//        context.move(to: CGPoint(x: rightX+linewidthAngle/2, y: topY))
//        context.addLine(to: CGPoint(x: rightX - wAngle, y: topY))
//        
//        // 右上角垂直线
//        context.move(to: CGPoint(x: rightX, y: topY-linewidthAngle/2))
//        context.addLine(to: CGPoint(x: rightX, y: topY + hAngle))
//        
//        // 右下角水平线
//        context.move(to: CGPoint(x: rightX+linewidthAngle/2, y: bottomY))
//        context.addLine(to: CGPoint(x: rightX - wAngle, y: bottomY))
//        
//        // 右下角垂直线
//        context.move(to: CGPoint(x: rightX, y: bottomY+linewidthAngle/2))
//        context.addLine(to: CGPoint(x: rightX, y: bottomY - hAngle))
        context.strokePath()
    }
}
