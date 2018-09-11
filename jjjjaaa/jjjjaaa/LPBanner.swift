//
//  LPBanner.swift
//  jjjjaaa
//
//  Created by 路鹏 on 2018/9/11.
//  Copyright © 2018年 路鹏. All rights reserved.
//

import UIKit

class LPBanner: UIView,UIScrollViewDelegate {
    public var modelArr:[String]!{
        didSet{
            self.itemCount = modelArr.count;
            self.releaseTimer();
            self.subviews.forEach{ item in
                item.removeFromSuperview();
            };
            self.createSubView();
        }
    }
    public var isStopTimer:Bool!{
        didSet{
            if (isStopTimer) {
                self.releaseTimer();
            }else{
                if (self.timer != nil || self.itemCount < 2) {
                    return;
                }
                if (self.itemCount >= 2) {
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollViewAutomaticDecelerating), userInfo: nil, repeats: true);
                }
            }
        }
    }
    var itemCount:Int = 0;
    var scrollView:UIScrollView!;
    var pageControl:UIPageControl!;
    var timer:Timer!;
    let appW = UIScreen.main.bounds.size.width;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    func createSubView(){
        self.pageControl = UIPageControl();
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = UIColor.white;
        self.pageControl.pageIndicatorTintColor = UIColor.gray;
        self.pageControl.backgroundColor = UIColor.yellow;
        self.addSubview(self.pageControl);
        pageControl.center = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height-20);
        self.pageControl.numberOfPages = self.itemCount;
        self.pageControl.defersCurrentPageDisplay = true;
        
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        self.scrollView.contentSize = CGSize.init(width: appW * CGFloat(self.itemCount), height: 0);
        if (self.itemCount == 2) {self.scrollView.contentSize = CGSize.init(width: appW*3, height: 0)};
        if (self.itemCount == 1) {self.scrollView.contentSize = CGSize.init(width: appW+1, height: 0)};
        self.scrollView.isPagingEnabled = true;
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.delegate = self;
        self.scrollView.bounces = false;
        if (self.itemCount < 2) {self.scrollView.bounces = true};
        if (self.itemCount > 1) {self.scrollView.contentOffset = CGPoint.init(x: appW, y: 0)};
        self.addSubview(self.scrollView);
        self.bringSubview(toFront: self.pageControl);
        
        var count = self.itemCount;
        if (self.itemCount == 2) {count = 3};
        
        for i in 0..<count {
            let btn = UIButton.init(type: UIButtonType.custom);
            btn.frame = CGRect.init(x: i>(count-2) ? (i==(count-1) ? 0 : appW) : appW*CGFloat(i+1), y: 0, width: appW, height: self.frame.size.height);
            btn.tag = i;
            if (self.itemCount == 2 && i == 2) {
                btn.tag = 1;
            }
            btn.setTitle(String(i), for: UIControlState.normal);
            btn.setTitleColor(UIColor.yellow, for: UIControlState.normal);
            btn.backgroundColor = UIColor(red: CGFloat(arc4random()%255) / 255, green: CGFloat(arc4random()%255) / 255, blue: CGFloat(arc4random()%255) / 255, alpha: 1);
            self.scrollView.addSubview(btn);
            
        }
        if (self.itemCount < 2) {
            return;
        }
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollViewAutomaticDecelerating), userInfo: nil, repeats: true);
    }
    
    
    //MARK: - 减速停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.scrollView && self.itemCount >= 2) {
            let page = Int(scrollView.contentOffset.x / appW);
            page > 1 ? self.repetitionDeceleratingIsRight(isRight: true, count: page-1) : self.repetitionDeceleratingIsRight(isRight: false, count: 1-page);
            if (self.itemCount == 2) {
                self.specialLayout();
            }
        }
    }
    //MARK: - 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (scrollView == self.scrollView) {
            self.releaseTimer();
        }
    }
    //MARK: - 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView == self.scrollView && self.itemCount > 1) {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollViewAutomaticDecelerating), userInfo: nil, repeats: true);
        }
    }
    //MARK: - scrollview动画结束
    func scrollViewAutomaticDecelerating(){
        var count = self.itemCount;
        if (self.itemCount == 2) {count = 3}
        
        for btn in self.scrollView.subviews {
            var rect = btn.frame;
            rect.origin.x -= appW;
            
            UIView.animate(withDuration: 0.5, animations: {
                btn.frame = rect;
            }) { (_) in
                if (Int(rect.origin.x / self.appW) == 1) {
                    self.pageControl.currentPage = btn.tag;
                }
                if (self.itemCount == 2) {
                    self.specialLayout();
                }
            }
            
            if (rect.origin.x < 0) {
                rect.origin.x += appW * CGFloat(count);
                btn.frame = rect;
            }
        }
        
        self.scrollView.contentOffset = CGPoint.init(x: appW, y: 0);
    }
    
    //MARK: - 等于2特殊情况下重新布局
    func specialLayout(){
        var btn:UIButton!;
        var tag:Int!;
        for subView in self.scrollView.subviews {
            if let subBtn = subView as? UIButton {
                if (subBtn.frame.origin.x == appW){
                    btn = subBtn;
                }
            }
        }
        if (btn.tag == 0) { tag = 1;}
        else{tag = 0;}
        for subView in self.scrollView.subviews {
            if let subBtn = subView as? UIButton {
                if (subBtn != btn) {
                    subBtn.tag = tag;
                }
            }
        }
    }
    //MARK: - button重新布局
    func repetitionDeceleratingIsRight(isRight:Bool,count:Int){
        var newCount = self.itemCount;
        if (self.itemCount == 2) {newCount = 3;}
        
        for btn in self.scrollView.subviews {
            var rect = btn.frame;
            if (isRight) {
                rect.origin.x -= appW * CGFloat(count);
            }else{
                rect.origin.x += appW * CGFloat(count);
            }
            
            if (rect.origin.x<0) {
                rect.origin.x += appW * CGFloat(newCount);
            }
            
            if (rect.origin.x>appW * CGFloat(newCount-1)) {
                rect.origin.x -= appW * CGFloat(newCount);
            }
            
            btn.frame = rect;
            if (rect.origin.x/appW == 1) {
                self.pageControl.currentPage = btn.tag;
            }
            
        }
        self.scrollView.contentOffset = CGPoint.init(x: appW, y: 0);
    }
    //MARK: - 释放计时器
    func releaseTimer(){
        if (self.timer != nil) {
            self.timer.invalidate();
            self.timer = nil;
        }
    }
    
    deinit {
        self.releaseTimer();
    }
    
}

