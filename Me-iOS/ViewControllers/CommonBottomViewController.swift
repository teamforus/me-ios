//
//  MLoginBottomViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp

class CommonBottomViewController: UIViewController {

    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var topView: UIView!
    
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    private var halfWayPoint = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(toglePullUpView), name: Notification.Name("togleStateWindow"), object: nil)
    }
    
    @objc func toglePullUpView(){
        if pullUpController.state == .expanded{
            self.view.isHidden = true
        }else{
            self.view.isHidden = false
        }
        pullUpController.toggleState(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommonBottomViewController: ISHPullUpStateDelegate, ISHPullUpSizingDelegate{
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height;
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
        if state == .collapsed {
            self.view.isHidden = true
        }else if state == .intermediate {
            pullUpController.toggleState(animated: true)
        }
    }
    
}
