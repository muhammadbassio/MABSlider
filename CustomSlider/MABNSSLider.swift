//
//  MABNSSLider.swift
//  Tuner
//
//  Created by Muhammad Bassio on 11/8/14.
//  Copyright (c) 2014 Muhammad Bassio. All rights reserved.
//

import Cocoa


class Helpers {
  
  class func CGPathFromNSBezierPath(nsPath: NSBezierPath) -> CGPath! {
    
    if nsPath.elementCount == 0 {
      return nil
    }
    
    let path = CGPathCreateMutable()
    var didClosePath = false
    var i:Int = 0
    
    for i = 0; i < nsPath.elementCount; i++ {
      var points = [NSPoint](count: 3, repeatedValue: NSZeroPoint)
      
      switch nsPath.elementAtIndex(i, associatedPoints: &points) {
      case .MoveToBezierPathElement:CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
      case .LineToBezierPathElement:CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
      case .CurveToBezierPathElement:CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
      case .ClosePathBezierPathElement:CGPathCloseSubpath(path)
      didClosePath = true
      }
    }
    
    if !didClosePath {
      CGPathCloseSubpath(path)
    }
    
    return CGPathCreateCopy(path)
  }
}

class MABSliderCell: NSSliderCell {
  
  var knobImage:NSImage!
  var barFillImage:NSImage!
  var barFillBeforeKnobImage:NSImage!
  var barLeftAgeImage:NSImage!
  var barRightAgeImage:NSImage!
  
  private var _currentKnobRect:NSRect!
  private var _barRect:NSRect!
  private var _flipped:Bool = false
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    //fatalError("init(coder:) has not been implemented")
  }
  
  override init() {
    super.init()
  }
  
  init(knob:NSImage, barFill:NSImage, barFillBeforeKnob:NSImage, barLeftAge:NSImage, barRightAge:NSImage) {
    
    knobImage = knob;
    barFillImage = barFill;
    barFillBeforeKnobImage = barFillBeforeKnob;
    barLeftAgeImage = barLeftAge;
    barRightAgeImage = barRightAge;
    super.init()
    
  }
  
  override func drawKnob(knobRect: NSRect) {
    
    if (knobImage == nil) {
      super.drawKnob(knobRect)
      return;
    }
    
    _currentKnobRect = knobRect;
    drawBarInside(_barRect, flipped: _flipped)
    self.controlView?.lockFocus()
    
    //  We crete this to make a right proportion for the knob rect
    //  For example you knobImage width is longer then allowable
    //  this line will position you knob normally inside the slider
    var newOriginX:CGFloat = knobRect.origin.x *
    (_barRect.size.width - (knobImage.size.width - knobRect.size.width)) / _barRect.size.width;
    
    knobImage.drawAtPoint(NSPoint(x: newOriginX, y: knobRect.origin.y), fromRect: NSRect(x: 0, y: 0, width: knobImage.size.width, height: knobImage.size.height), operation: NSCompositingOperation.CompositeSourceOver, fraction: 1)
    
    //knobImage.drawInRect(NSRect(x: newOriginX, y: -7, width: knobImage.size.width, height: knobImage.size.height))
    
    //[_knobImage compositeToPoint:NSMakePoint(newOriginX, knobRect.origin.y + _knobImage.size.height) operation:NSCompositeSourceOver];
    self.controlView?.unlockFocus()
    
  }
  
  override func drawBarInside(aRect: NSRect, flipped: Bool) {
    if( (knobImage == nil) && (barFillImage == nil) && (barFillBeforeKnobImage == nil) &&
    (barLeftAgeImage == nil) && (barRightAgeImage == nil) ) {
      super.drawBarInside(aRect, flipped: flipped)
        return;
    }
    _barRect = aRect;
    _flipped = flipped;
    
    var beforeKnobRect:NSRect = createBeforeKnobRect();
    var afterKnobRect:NSRect = createAfterKnobRect();
    
    //  Sometimes you can see the ages off you bar
    //  even if your knob is at the end or
    //  at the beginning of it. It's about one pixel
    //  but this help to hide that edges
    if( self.minValue != self.doubleValue ) {
      NSDrawThreePartImage(beforeKnobRect, barLeftAgeImage, barFillBeforeKnobImage, barFillBeforeKnobImage,
        false, NSCompositingOperation.CompositeSourceOver, 1.0, flipped);
    }
    if( self.maxValue != self.doubleValue ) {
      NSDrawThreePartImage(afterKnobRect, barFillImage, barFillImage, barRightAgeImage,
        false, NSCompositingOperation.CompositeSourceOver, 1.0, flipped);
    }
  }
  
  func createBeforeKnobRect() -> NSRect {
    if (_currentKnobRect != nil) {
      var beforeKnobRect:NSRect = _barRect;
      beforeKnobRect.size.width = _currentKnobRect.origin.x + knobImage.size.width / 2;
      beforeKnobRect.size.height = barFillBeforeKnobImage.size.height;
      beforeKnobRect.origin.y = (knobImage.size.height / 2) - (beforeKnobRect.size.height / 2);
      return beforeKnobRect;
    }
    return NSRect(x: 0, y: 0, width: 0, height: 0)
  }
  
  func createAfterKnobRect() -> NSRect {
    if (_currentKnobRect != nil) {
      var afterKnobRect:NSRect = _currentKnobRect;
      afterKnobRect.origin.x += knobImage.size.width / 2;
      afterKnobRect.size.width = _barRect.size.width - afterKnobRect.origin.x;
      afterKnobRect.size.height = barFillImage.size.height;
      afterKnobRect.origin.y = (knobImage.size.height / 2) - (afterKnobRect.size.height / 2);
      return afterKnobRect;
    }
    return NSRect(x: 0, y: 0, width: 0, height: 0)
  }
  
  func setBarFillImage(bFillImage:NSImage) {
    barFillImage = bFillImage;
    if(barFillBeforeKnobImage == nil) {
      barFillBeforeKnobImage = bFillImage;
    }
  }
  
  func setBarFillBeforeKnobImage(bFillBeforeKnobImage:NSImage) {
    barFillBeforeKnobImage = bFillBeforeKnobImage;
    if(barFillImage == nil) {
      barFillImage = bFillBeforeKnobImage;
    }
  }
  
}

class MABSlider:NSSlider {
  
  var currentValue:CGFloat = 0
  
  override func setNeedsDisplayInRect(invalidRect: NSRect) {
    super.setNeedsDisplayInRect(invalidRect)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if ((self.cell()?.isKindOfClass(MABSliderCell)) == false) {
      var cell:MABSliderCell = MABSliderCell()
      self.setCell(cell)
    }
  }
  
  init(knob:NSImage, barFill:NSImage, barFillBeforeKnob:NSImage, barLeftAge:NSImage, barRightAge:NSImage) {
    super.init()
    self.setCell(MABSliderCell(knob: knob, barFill: barFill, barFillBeforeKnob: barFillBeforeKnob, barLeftAge: barLeftAge, barRightAge: barRightAge))
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    //fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
  }
  
  func knobImage() -> NSImage {
    var cell = self.cell() as MABSliderCell
    return cell.knobImage
  }
  
  func setKnobImage(image:NSImage) {
    var cell = self.cell() as MABSliderCell
    cell.knobImage = image
  }
  
  func barFillImage() -> NSImage {
    var cell = self.cell() as MABSliderCell
    return cell.barFillImage
  }
  
  func setBarFillImage(image:NSImage) {
    var cell = self.cell() as MABSliderCell
    cell.barFillImage = image
  }
  
  func barFillBeforeKnobImage() -> NSImage {
    var cell = self.cell() as MABSliderCell
    return cell.barFillBeforeKnobImage
  }
  
  func setBarFillBeforeKnobImage(image:NSImage) {
    var cell = self.cell() as MABSliderCell
    cell.barFillBeforeKnobImage = image
  }
  
  func barLeftAgeImage() -> NSImage {
    var cell = self.cell() as MABSliderCell
    return cell.barLeftAgeImage
  }
  
  func setBarLeftAgeImage(image:NSImage) {
    var cell = self.cell() as MABSliderCell
    cell.barLeftAgeImage = image
  }
  
  func barRightAgeImage() -> NSImage {
    var cell = self.cell() as MABSliderCell
    return cell.barRightAgeImage
  }
  
  func setBarRightAgeImage(image:NSImage) {
    var cell = self.cell() as MABSliderCell
    cell.barRightAgeImage = image
  }
  
  
}



