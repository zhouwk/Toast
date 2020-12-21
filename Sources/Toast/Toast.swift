//
//  Toast.swift
//  EasyApp
//
//  Created by 周伟克 on 2020/12/7.
//


import UIKit

let ToastDefaultPadding = CGFloat(15)
let ToastItemDefaultMargin = CGFloat(5)
let ToastKVOHiddenKeyPath = "hidden"
let ToastKVOImageKeyPath = "image"

let ToastDefaultBackgroundColor = UIColor.clear
let ToastDefaultPrimaryColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

public class Toast: UIView {
        
    let foregroundBtn = UIButton()
    let contentView = UIView()
    public let indicator = UIActivityIndicatorView(style: .white)
    public let imageView = UIImageView()
    public let label = UILabel()
    
    public var isUserInteractionBlocked = false {
        didSet {
            foregroundBtn.isEnabled = isUserInteractionBlocked
        }
    }
    
    var itemsVerticalMargins = [NSLayoutConstraint]()
    var dismissWork: DispatchWorkItem?
    lazy var imageViewConstrants = [NSLayoutConstraint]()
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        
        contentView.backgroundColor = ToastDefaultBackgroundColor
        contentView.layer.cornerRadius = 5
        addSubview(contentView)
        addConstraint(.init(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(.init(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=50-[contentView]", options: [], metrics: nil, views: ["contentView": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=50-[contentView]", options: [], metrics: nil, views: ["contentView": contentView]))
        
        for item in [indicator, imageView, label] {
            contentView.addSubview(item)
            contentView.addConstraint(.init(item: item, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=padding-[item]", options: [], metrics: ["padding": ToastDefaultPadding + 10], views: ["item": item]))
        }
        
        label.textColor = ToastDefaultPrimaryColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        itemsVerticalMargins = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[indicator][imageView][label]-padding-|", options: [], metrics: ["padding": ToastDefaultPadding], views: ["indicator": indicator, "imageView": imageView, "label": label])
        contentView.addConstraints(itemsVerticalMargins)
        
        indicator.color = ToastDefaultPrimaryColor
        indicator.addObserver(self, forKeyPath: ToastKVOHiddenKeyPath, options: .new, context: nil)
        imageView.addObserver(self, forKeyPath: ToastKVOImageKeyPath, options: .new, context: nil)
        
        
        for item in [foregroundBtn, contentView, indicator, imageView, label] {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    
        foregroundBtn.isEnabled = false
        addSubview(foregroundBtn)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[foregroundBtn]-0-|", options: [], metrics: nil, views: ["foregroundBtn": foregroundBtn]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[foregroundBtn]-0-|", options: [], metrics: nil, views: ["foregroundBtn": foregroundBtn]))
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == ToastKVOHiddenKeyPath {
        }
        if keyPath == ToastKVOImageKeyPath {
            if change?[.newKey] as? UIImage == nil {
                if imageViewConstrants.isEmpty {
                    imageViewConstrants.append(.init(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
                    imageViewConstrants.append(.init(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
                    imageView.addConstraints(imageViewConstrants)
                }
            } else {
                imageView.removeConstraints(imageViewConstrants)
                imageViewConstrants.removeAll()
            }
        }
        contentView.layoutIfNeeded()
    }
    
        
    func relayoutItemsInVertial() {
        
        let imageIntrinsicContentHeight = max(imageView.intrinsicContentSize.height, 0)
        
        // imageView-to-indicator
        itemsVerticalMargins[1].constant = indicator.isHidden ? -indicator.intrinsicContentSize.height : (imageIntrinsicContentHeight == 0 ? 0 : ToastItemDefaultMargin)
        
        let labelIntrinsicContentHeight = max(label.intrinsicContentSize.height, 0)
        // label-to-imageView
        itemsVerticalMargins[2].constant = imageIntrinsicContentHeight == 0 ? 0 : (labelIntrinsicContentHeight == 0 ? 0 : ToastItemDefaultMargin)
        
        
    }
    
    
    func cancelDismissWork() {
        dismissWork?.cancel()
    }
    
    
    public func dismiss(_ afterDelay: Double = 0.7) {
        cancelDismissWork()
        dismissWork = DispatchWorkItem(block: { [weak self] in
            self?.removeFromSuperview()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay,
                                      execute: dismissWork!)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        relayoutItemsInVertial()
        super.layoutSubviews()
    }
    
    deinit {
        indicator.removeObserver(self, forKeyPath: ToastKVOHiddenKeyPath)
        imageView.removeObserver(self, forKeyPath: ToastKVOImageKeyPath)
    }
}

