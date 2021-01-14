//
//  UIViewToastExtension.swift
//  EasyApp
//
//  Created by 周伟克 on 2020/12/7.
//

import UIKit

extension UIView {
        
    public var toast: Toast? {
        return subviews.first { $0 is Toast } as? Toast
    }
        
    public func showToast(_ text: String? = nil,
                          numberOfLines: Int = 1,
                          image: UIImage? = nil,
                          color: UIColor? = nil,
                          bgColor: UIColor? = nil) {
        showBasicToast(text,
                       numberOfLines: numberOfLines,
                       image: image,
                       autorotate: false,
                       color: color,
                       bgColor: bgColor,
                       autoDismiss: true)
    }

    public func showLoading(_ text: String? = nil,
                            numberOfLines: Int = 1,
                            color: UIColor? = nil,
                            bgColor: UIColor? = nil) {
        
        let image = UIImage(named: "loading", in: .module, compatibleWith: nil)
        showBasicToast(text,
                       numberOfLines: numberOfLines,
                       image: image,
                       autorotate: true,
                       color: color,
                       bgColor: bgColor,
                       isUserInteractionBlocked: true)
    }
    
    public func showBasicToast(_ text: String? = nil,
                               numberOfLines: Int = 1,
                               image: UIImage? = nil,
                               autorotate: Bool = false,
                               color: UIColor? = nil,
                               bgColor: UIColor? = nil,
                               autoDismiss: Bool = false,
                               isUserInteractionBlocked: Bool = false) {
        let toast: Toast
        if self.toast != nil {
            toast = self.toast!
            bringSubviewToFront(toast)
            toast.cancelDismissWork()
        } else {
            toast = Toast(frame: bounds)
            addSubview(toast)
        }
        toast.label.text = text
        toast.label.numberOfLines = numberOfLines
        toast.imageView.image = image
        toast.label.textColor = color ?? ToastConfig.textColor
        toast.contentView.backgroundColor = bgColor ?? ToastConfig.backgroundColor
        toast.isUserInteractionBlocked = isUserInteractionBlocked
        toast.autorotate = autorotate
        if autoDismiss {
            toast.dismiss()
        }
        toast.layoutIfNeeded()
    }
}


extension UIViewController {
    public var toast: Toast? {
        return view.subviews.first { $0 is Toast } as? Toast
    }

    public func showToast(_ text: String? = nil,
                          numberOfLines: Int = 1,
                          image: UIImage? = nil,
                          color: UIColor? = nil,
                          bgColor: UIColor? = nil) {
        view.showToast(text,
                       numberOfLines: numberOfLines,
                       image: image, 
                       color: color,
                       bgColor: bgColor)
    }

    public func showLoading(_ text: String? = nil,
                            numberOfLines: Int = 1,
                            color: UIColor? = nil,
                            bgColor: UIColor? = nil) {
        view.showLoading(text,
                         numberOfLines: numberOfLines,
                         color: color,
                         bgColor: bgColor)
    }
}

