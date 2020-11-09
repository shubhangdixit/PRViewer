//
//  PRBaseViewController.swift
//  PRViewer
//
//  Created by Shubhang Dixit on 09/11/20.
//  Copyright © 2020 Shubhang. All rights reserved.
//

import UIKit

class PRBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = allScreenBackgroundColor
    }
    
    func setUpHeader(forView hView : UIView) {
        hView.layer.masksToBounds = false
        hView.layer.shadowColor = UIColor.black.cgColor
        hView.layer.shadowOpacity = 0.5
        hView.layer.shadowOffset = CGSize(width: 0, height: 2)
        hView.layer.shadowRadius = 1
        
        hView.layer.shadowPath = UIBezierPath(rect: hView.bounds).cgPath
        hView.layer.shouldRasterize = true
        view.bringSubviewToFront(hView)
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
