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
        
    public func showToast(_ text: String?,
                          numberOfLines: Int = 1,
                          image: UIImage? = nil,
                          color: UIColor? = nil,
                          bgColor: UIColor? = nil) {
        showBasicToast(text,
                       numberOfLines: numberOfLines,
                       image: image,
                       animateIndicator: false,
                       color: color,
                       bgColor: bgColor,
                       autoDismiss: true)
    }

    public func showLoading(_ text: String?,
                            numberOfLines: Int = 1,
                            color: UIColor? = nil,
                            bgColor: UIColor? = nil) {
        showBasicToast(text,
                       numberOfLines: numberOfLines,
                       animateIndicator: true,
                       color: color,
                       bgColor: bgColor,
                       isUserInteractionBlocked: true)
    }
    
    public func showBasicToast(_ text: String?,
                               numberOfLines: Int = 1,
                               image: UIImage? = nil,
                               animateIndicator: Bool = false,
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
        toast.label.textColor = color ?? ToastDefaultPrimaryColor
        toast.indicator.color = color ?? ToastDefaultPrimaryColor
        toast.contentView.backgroundColor = bgColor ?? ToastDefaultBackgroundColor
        toast.isUserInteractionBlocked = isUserInteractionBlocked
        if animateIndicator {
            toast.indicator.startAnimating()
        } else {
            toast.indicator.stopAnimating()
        }
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

    public func showToast(_ text: String?,
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

    public func showLoading(_ text: String?,
                            numberOfLines: Int = 1,
                            color: UIColor? = nil,
                            bgColor: UIColor? = nil) {
        view.showLoading(text,
                         numberOfLines: numberOfLines,
                         color: color,
                         bgColor: bgColor)
    }
}

