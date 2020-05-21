//
//  ViewController.swift
//  csc600Project
//
//  Created by Jinan Huang on 5/11/20.
//  Copyright © 2020 Lum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!

    
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var arrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        trayDownOffset = 105
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        
        startingPointKartView1 = KartView1.center
        startingPointKartView0 = KartView0.center
        startingPointKartView4 = KartView4.center
        
    }
    

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
            print("translation \(translation)")
            let velocity = sender.velocity(in: view)
            
            if sender.state == .began {
                trayOriginalCenter = trayView.center
                print("Gesture began")
                
            } else if sender.state == .changed {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
                arrow.transform = CGAffineTransform(rotationAngle: CGFloat(180 * Double.pi / 180))
                print("Gesture is changing")
                
            } else if sender.state == .ended {
                if velocity.y > 0 {
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                        self.trayView.center = self.trayDown
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                        self.trayView.center = self.trayUp
                        self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi / 180))
                    }, completion: nil)
                }
                trayView.backgroundColor = getRandomColor()
                print("Gesture ended")
            }
        }
        
        func getRandomColor() -> UIColor {
            let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
            return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        }
    
    
    @IBAction func didPanCart(_ sender: UIPanGestureRecognizer) {
              let newGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanFace2(_:)))
              let translation = sender.translation(in: view)
              
              let deleteFace = UITapGestureRecognizer(target: self, action: #selector(noFace(_:)))
              deleteFace.numberOfTapsRequired = 2
              
              if sender.state == .began {
                  let imageView = sender.view as! UIImageView
                  newlyCreatedFace = UIImageView(image: imageView.image)
                  newlyCreatedFace.center = imageView.center
                  view.addSubview(newlyCreatedFace)
                  newlyCreatedFace.center = imageView.center
                  newlyCreatedFace.center.y += trayView.frame.origin.y
                  newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
                  newlyCreatedFace.isUserInteractionEnabled = true
                  newlyCreatedFace.addGestureRecognizer(newGesture)
                  newlyCreatedFace.addGestureRecognizer(deleteFace)
                  UIView.animate(withDuration: 0.2, animations: {
                    self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
                  })
              } else if sender.state == .changed {
                  newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
                  
              } else if sender.state == .ended {
                  UIView.animate(withDuration: 0.4, animations: {
                    self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
                  })
                  if (newlyCreatedFace.frame.origin.y > trayView.frame.origin.y) {
                      UIView.animate(withDuration: 0.5, animations: {
                          self.newlyCreatedFace.center = self.newlyCreatedFaceOriginalCenter
                      }, completion: { finished in
                          if finished {
                              self.newlyCreatedFace.removeFromSuperview()
                          }
                      })
                  }
                  
              }
          }

        @objc func didPanFace2(_ sender: UIPanGestureRecognizer) {
              
              let translation = sender.translation(in: view)
              
              if sender.state == .began {
                  newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
                  newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
              } else if sender.state == .changed {
                  newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
              } else if sender.state == .ended {
                  if (newlyCreatedFace.frame.origin.y > trayView.frame.origin.y) {
                      UIView.animate(withDuration: 2, animations: {
                          self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 0, y: 0)
                      }, completion: { finished in
                          if finished {
                              self.newlyCreatedFace.removeFromSuperview()
                          }
                      })
                  }
                  
              }
          }
          
          @objc func noFace(_ sender: UIPanGestureRecognizer){
              newlyCreatedFace.removeFromSuperview()
          }
    
    
    
    @IBOutlet weak var KartView1: UIImageView!
    @IBOutlet weak var KartView0: UIImageView!
    @IBOutlet weak var KartView4: UIImageView!
    
    var startingPointKartView1 = CGPoint()
    var startingPointKartView0 = CGPoint()
    var startingPointKartView4 = CGPoint()
    
    
    @IBAction func didPanKartView(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
            print("Location: x: \(location.x), y: \(location.y)")
        let kartView = sender.view!
            kartView.center = location
    }
    
    @IBAction func didPinchKartView(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        print("scale: \(scale)")
        let kartView = sender.view!
        kartView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    @IBAction func didRotateKartView(_ sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        print("rotation: \(rotation)")
        let kartView = sender.view!
        kartView.transform = CGAffineTransform(rotationAngle: rotation)
    }
    
    @IBAction func didTapKartView(_ sender: UITapGestureRecognizer) {
        print("Double tap recognized")
        let kartView = sender.view!
        kartView.center.x += 50
        
        UIView.animate(withDuration: 0.6) {
           kartView.center.x += 300
        }
    }
    
    @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) {
        
        KartView1.center = startingPointKartView1
        KartView0.center = startingPointKartView0
        KartView4.center = startingPointKartView4
        
        UIView.animate(withDuration: 0.8) {
            self.KartView1.center = self.startingPointKartView1
            self.KartView0.center = self.startingPointKartView0
            self.KartView4.center = self.startingPointKartView4
            
            self.KartView1.transform = CGAffineTransform.identity
            self.KartView0.transform = CGAffineTransform.identity
            self.KartView4.transform = CGAffineTransform.identity
            
        }
    }
    
    
}

