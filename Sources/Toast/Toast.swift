//
//  Toast.swift
//  EasyApp
//
//  Created by 周伟克 on 2020/12/7.
//


import UIKit

let ToastKVOImageKeyPath = "image"
let ToastRotateKeyPath = "transform.rotation.z"

public class Toast: UIView {
        
    let foregroundBtn = UIButton()
    let contentView = UIView()

    public let imageView = UIImageView()
    public let label = UILabel()
    public var autorotate = false {
        didSet {
            if !autorotate {
                imageView.layer.removeAllAnimations()
            } else if imageView.layer.animation(forKey: ToastRotateKeyPath) == nil {
                let anim = CABasicAnimation(keyPath: ToastRotateKeyPath)
                anim.toValue = CGFloat.pi * 2
                anim.duration = ToastConfig.rotationDuration
                anim.repeatCount = .infinity
                anim.isRemovedOnCompletion = false
                imageView.layer.add(anim, forKey: ToastRotateKeyPath)
            }
        }
    }
    
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
        contentView.backgroundColor = ToastConfig.backgroundColor
        contentView.layer.cornerRadius = 5
        addSubview(contentView)
        addConstraint(.init(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(.init(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=50-[contentView]", options: [], metrics: nil, views: ["contentView": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=50-[contentView]", options: [], metrics: nil, views: ["contentView": contentView]))
        
        for item in [imageView, label] {
            contentView.addSubview(item)
            contentView.addConstraint(.init(item: item, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=padding-[item]", options: [], metrics: ["padding": ToastConfig.padding.x], views: ["item": item]))
        }
        
        label.textColor = ToastConfig.textColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        itemsVerticalMargins = NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding-[imageView][label]-padding-|", options: [], metrics: ["padding": ToastConfig.padding.y], views: [ "imageView": imageView, "label": label])
        contentView.addConstraints(itemsVerticalMargins)
    
        imageView.addObserver(self, forKeyPath: ToastKVOImageKeyPath, options: .new, context: nil)
        
        
        for item in [foregroundBtn, contentView, imageView, label] {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    
        foregroundBtn.isEnabled = false
        addSubview(foregroundBtn)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[foregroundBtn]-0-|", options: [], metrics: nil, views: ["foregroundBtn": foregroundBtn]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[foregroundBtn]-0-|", options: [], metrics: nil, views: ["foregroundBtn": foregroundBtn]))
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
        itemsVerticalMargins[1].constant = imageIntrinsicContentHeight == 0 ? 0 : ToastConfig.itemMarginInV
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
        imageView.removeObserver(self, forKeyPath: ToastKVOImageKeyPath)
    }
}

