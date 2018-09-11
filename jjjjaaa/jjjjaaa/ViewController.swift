//
//  ViewController.swift
//  jjjjaaa
//
//  Created by 路鹏 on 2018/9/11.
//  Copyright © 2018年 路鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         let appW = UIScreen.main.bounds.size.width;
        let aa = LPBanner();
        aa.frame = CGRect.init(x: 0, y: 100, width: appW, height: 300);
        aa.backgroundColor = UIColor.red;
        aa.modelArr = ["aa","aa"];
        self.view.addSubview(aa);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

