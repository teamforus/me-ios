//
//  KeyboardDismissHandler.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 04.11.2024.
//  Copyright © 2024 Tcacenco Daniel. All rights reserved.
//

import UIKit

public final class KeyboardDismissHandler: NSObject, UIGestureRecognizerDelegate {
    fileprivate(set) var keyboardFrame = CGRect.zero {
        didSet {
            var height: CGFloat = max(0.0, UIView.screenHeight - keyboardFrame.minY)
            if height > 0 { height -= UIView.bottomInset }
            visibleHeight = height
        }
    }
    fileprivate(set) var visibleHeight: CGFloat = 0.0 {
        didSet { onChangedKeyboardHeight?(visibleHeight) }
    }
    public var onChangedKeyboardHeight: ((CGFloat) -> Void)?
    public var onKeyboardDidShow: (() -> ())?

    private var panGesture: UIPanGestureRecognizer?

    private let _willChangeFrame = UIResponder.keyboardWillChangeFrameNotification
    private let _willHide = UIResponder.keyboardWillHideNotification
    private let _didShow = UIResponder.keyboardDidShowNotification

    public func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHandler), name: _willChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHandler), name: _willHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidShowHandler), name: _didShow, object: nil)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        panGesture?.delegate = self
        UIApplication.shared.windows.first?.addGestureRecognizer(panGesture!)
    }

    public func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: _willChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: _willHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: _didShow, object: nil)

        if let gesture = panGesture {
            panGesture?.view?.removeGestureRecognizer(gesture)
            panGesture = nil
        }
    }

    // MARK: Action
    @objc func onKeyboardHandler(_ n: Notification) {
        guard
            let frame = (n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            n.userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? Bool == true
        else { return }

        var newFrame = frame

        switch n.name {
        case _willChangeFrame:
            newFrame.origin.y = UIView.screenHeight - newFrame.height
        case _willHide:
            newFrame.origin.y = UIView.screenHeight
            newFrame.size.height = 0
        default:
            break
        }

        keyboardFrame = newFrame
    }

    @objc func onKeyboardDidShowHandler() {
        onKeyboardDidShow?()
    }

    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        guard let window = UIApplication.shared.windows.first, gesture.state == .changed
        else { return }

        let origin = gesture.location(in: window)
        keyboardFrame.origin.y = max(origin.y, UIView.screenHeight - keyboardFrame.height)
    }

    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: gestureRecognizer.view)
        var view = gestureRecognizer.view?.hitTest(point, with: nil)
        while let candidate = view {
            if let scrollView = candidate as? UIScrollView, scrollView.keyboardDismissMode == .interactive {
                return true
            }
            view = candidate.superview
        }
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer == panGesture
    }
}
