//
//  ViewController.swift
//  Layouts
//
//  Created by Grant Maloney on 9/14/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


class ViewController: UIViewController {

    var imageView = UIImageView()
    var label = UILabel()
    
    var horizontalStackView = UIStackView()
    
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    var leadingConstraintLabel: NSLayoutConstraint?
    var trailingConstraintLabel: NSLayoutConstraint?
    var topConstraintLabel: NSLayoutConstraint?
    var bottomConstraintLabel: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.alpha = 0
        label.alpha = 0
        label.font = label.font.withSize(25)
        imageView.load(url: URL(string: "https://vignette.wikia.nocookie.net/melifaro/images/6/6f/Moon-Vector-PNG.png/revision/latest?cb=20170608195222&path-prefix=ru")!)
        imageView.isUserInteractionEnabled = false
        
        imageView.contentMode = .scaleAspectFit  // this tells the imageView how to display the image in it
        imageView.clipsToBounds = true  // not really needed since doing scaleAspectFit, but be aware it exists
        view.addSubview(imageView) // this adds the imageView as a child of the View Controller's container view
        view.addSubview(label)
        // why the following? https://stackoverflow.com/questions/47800210/when-should-translatesautoresizingmaskintoconstraints-be-set-to-true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 20.0)
        
        trailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -20.0)
        
        topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 20.0)
        
        bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -20.0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.textAlignment = .center
        
        leadingConstraint?.isActive = true
        trailingConstraint?.isActive = true
        topConstraint?.isActive = true
        bottomConstraint?.isActive = true
        
        leadingConstraintLabel?.isActive = true
        trailingConstraintLabel?.isActive = true
        topConstraintLabel?.isActive = true
        bottomConstraintLabel?.isActive = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    func update() {
        UIView.animate(withDuration: 5.0, delay: 0, options: .curveEaseIn, animations: {
            self.imageView.center.y -= 120
            self.imageView.alpha = 100
        }, completion: { finished in
            self.imageView.isUserInteractionEnabled = true
            self.imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleMovement)))
            self.label.text = "Drag the moon!"
            self.label.alpha = 100
            self.label.textColor = UIColor.white
        })
    }

    @objc
    func handleMovement(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

}

