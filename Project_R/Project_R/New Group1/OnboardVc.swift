//
//  OnboardVc.swift
//  SarvodayaHB
//
//  Created by CZ Ltd on 2/2/18.
//  Copyright © 2018 CZ Ltd. All rights reserved.
//

import UIKit

class OnboardVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PrefsManager.sharedinstance.isFirstTime = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
