//
//  ViewController.swift
//  FingerPaint
//
//  Created by Dmytro Yashkir on 2016-12-15.
//  Copyright © 2016 Dmytro Yashkir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    //drawing properties
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 40.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var currentColor = UIColor.red.cgColor
    
    @IBOutlet weak var rButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var gButton: UIButton!
    @IBOutlet weak var mButton: UIButton!
    
    @IBAction func saveButtonPress(_ sender: Any) {
        if let image = self.imageView.image {
            let imageData = UIImageJPEGRepresentation(image, 0.6)
            let compressedJPGImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
            
            let alert = UIAlertView(title: "Done",
                                    message: "Your image has been saved to Photo Library!",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }else{
            let alert = UIAlertView(title: "Nope",
                                    message: "Draw something before saving!",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()

        }
    }
    @IBAction func eraserButton(_ sender: Any) {
        currentColor = UIColor.white.cgColor
    }
    
    @IBAction func redButton(_ sender: Any) {
        currentColor = UIColor.red.cgColor
    }
    @IBAction func blueButton(_ sender: Any) {
        currentColor = UIColor.blue.cgColor
    }
    @IBAction func greenButton(_ sender: Any) {
        currentColor = UIColor.green.cgColor
    }
    @IBAction func pinkButton(_ sender: Any) {
        currentColor = UIColor.magenta.cgColor
    }
    
    
    @IBAction func clearButton(_ sender: Any) {
        imageView.image=nil
    }
    @IBOutlet weak var clearButton: UIButton!
    override func viewDidLoad() {
        clearButton.layer.cornerRadius = 10
        rButton.layer.cornerRadius = 10
        gButton.layer.cornerRadius = 10
        bButton.layer.cornerRadius = 10
        mButton.layer.cornerRadius = 10
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.imageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        
        imageView.image?.draw(in: imageView.bounds)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(currentColor)
            context.setBlendMode(CGBlendMode.normal)
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            imageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            self.drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }

}

