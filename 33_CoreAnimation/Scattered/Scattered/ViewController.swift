//
//  ViewController.swift
//  Scattered
//
//  Created by Jason Zheng on 4/21/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  var imageLayers = [CALayer]()
  var textLayer: CATextLayer!
  var text: String? {
    didSet {
        let font = NSFont.systemFont(ofSize: textLayer.fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        var size = text?.size(withAttributes: attributes) ?? CGSize.zero
      size.width = ceil(size.width)
      size.height = ceil(size.height)
      textLayer.bounds = NSRect(origin: CGPoint.zero, size: size)
      textLayer.superlayer?.bounds = NSRect(x: 0, y: 0, width: size.width + 20, height: size.height + 16)
      textLayer.string = text
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Set the view to be layer-hosting
    view.layer = CALayer()
    view.wantsLayer = true
    
    let textContainer = CALayer()
    textContainer.anchorPoint = CGPoint.zero
    textContainer.position = CGPoint(x: 10, y: 10)
    textContainer.zPosition = 100
    textContainer.backgroundColor = NSColor.blue.cgColor
    textContainer.borderColor = NSColor.white.cgColor
    textContainer.borderWidth = 2
    textContainer.cornerRadius = 15
    textContainer.shadowOpacity = 0.5
    view.layer!.addSublayer(textContainer)
    
    let textLayer = CATextLayer()
    textLayer.anchorPoint = CGPoint.zero
    textLayer.position = CGPoint(x: 10, y: 6)
    textLayer.zPosition = 100
    textLayer.fontSize = 24
    textLayer.foregroundColor = NSColor.white.cgColor
    
    self.textLayer = textLayer
    textContainer.addSublayer(textLayer)
    
    // Reply on text's didSet to update textLayer's bounds
    text = "Loading..."
  }
  
  @IBAction func loadImages(_ sender: NSButton) {
    for layer in imageLayers {
      layer.removeFromSuperlayer()
    }
    
    let url = URL(fileURLWithPath: "/Library/Desktop Pictures")
    addImagesFromFolderURL(folderURL: url)
  }

  func addImagesFromFolderURL(folderURL: URL) {
    let t0 = NSDate.timeIntervalSinceReferenceDate
    var allowedFiles = 10
    let fileManager = FileManager()
    let enumerator = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: nil, options:  FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants, errorHandler:nil)
    while let url = enumerator?.nextObject() as? NSURL {
      var isDirectory: AnyObject?
      do {
        try url.getResourceValue(&isDirectory, forKey: URLResourceKey.isDirectoryKey)
        if let isDirectory = isDirectory as? NSNumber, isDirectory.boolValue == false {
            if let image = NSImage(contentsOf: url as URL) {
            allowedFiles -= 1
            if allowedFiles < 0 {
              break
            }
            let thumbImage = thumbImageFromImage(image: image)
            presentImage(image: thumbImage)
            let t1 = NSDate.timeIntervalSinceReferenceDate
            let interval = t1 - t0
            text = String(format: "%0.1fs", interval)
          }
        }
      } catch {
        
      }
    }
  }
  
  func thumbImageFromImage(image: NSImage) -> NSImage {
    let targetHeight: CGFloat = 100
    let imageSize = image.size
    let smallerImageSize = NSSize(width: imageSize.width * targetHeight / imageSize.height, height: targetHeight)
    let smallerImage = NSImage(size: smallerImageSize, flipped: false) { rect -> Bool in
        image.draw(in: rect)
      return true
    }
    return smallerImage
  }
  
  func presentImage(image: NSImage) {
    let superlayerBounds = view.layer!.bounds
    
    let center = CGPoint(x: superlayerBounds.midX, y: superlayerBounds.midY)
    
    let imageBounds = CGRect(origin: CGPoint.zero, size: image.size)
    
    let randomPoint =
      CGPoint(x: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxX))),
              y: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxY))))
    
    let timingFunction
        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    
    let positionAnimation = CABasicAnimation()
    positionAnimation.fromValue = NSValue(point: center)
    positionAnimation.duration = 1.5
    positionAnimation.timingFunction = timingFunction
    
    let boundsAnimation = CABasicAnimation()
    boundsAnimation.fromValue = NSValue(rect: CGRect.zero)
    boundsAnimation.duration = 1.5
    boundsAnimation.timingFunction = timingFunction
    
    let layer = CALayer()
    layer.contents = image
    layer.actions =
      ["position" : positionAnimation,
       "bounds"   : boundsAnimation]
    imageLayers.append(layer)
    
    CATransaction.begin()
    view.layer!.addSublayer(layer)
    layer.position = randomPoint
    layer.bounds = imageBounds
    CATransaction.commit()
  }
}

