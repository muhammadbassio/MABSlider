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
        
        let path = CGMutablePath()
        var didClosePath = false
        
        for i in 0..<nsPath.elementCount {
            var points = [NSPoint](repeating: NSZeroPoint, count: 3)
            
            switch nsPath.element(at: i, associatedPoints: &points) {
            case .moveToBezierPathElement: path.move(to: points[0])
            case .lineToBezierPathElement: path.addLine(to: points[0])
            case .curveToBezierPathElement: path.addCurve(to: points[0], control1: points[1], control2: points[2])
            case .closePathBezierPathElement: path.closeSubpath()
            didClosePath = true
            }
        }
        
        if !didClosePath {
            path.closeSubpath()
        }
        
        return path.copy()
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
    
    override func drawKnob(_ knobRect: NSRect) {
        
        if (knobImage == nil) {
            super.drawKnob(knobRect)
            return;
        }
        
        _currentKnobRect = knobRect;
        drawBar(inside: _barRect, flipped: _flipped)
        self.controlView?.lockFocus()
        
        //  We crete this to make a right proportion for the knob rect
        //  For example you knobImage width is longer then allowable
        //  this line will position you knob normally inside the slider
        let newOriginX:CGFloat = knobRect.origin.x *
            (_barRect.size.width - (knobImage.size.width - knobRect.size.width)) / _barRect.size.width;
        
        knobImage.draw(at: NSPoint(x: newOriginX, y: knobRect.origin.y), from: NSRect(x: 0, y: 0, width: knobImage.size.width, height: knobImage.size.height), operation: NSCompositingOperation.sourceOver, fraction: 1)
        
        //knobImage.drawInRect(NSRect(x: newOriginX, y: -7, width: knobImage.size.width, height: knobImage.size.height))
        
        //[_knobImage compositeToPoint:NSMakePoint(newOriginX, knobRect.origin.y + _knobImage.size.height) operation:NSCompositeSourceOver];
        self.controlView?.unlockFocus()
        
    }
    
    override func drawBar(inside aRect: NSRect, flipped: Bool) {
        if( (knobImage == nil) && (barFillImage == nil) && (barFillBeforeKnobImage == nil) &&
            (barLeftAgeImage == nil) && (barRightAgeImage == nil) ) {
            super.drawBar(inside: aRect, flipped: flipped)
            return;
        }
        _barRect = aRect;
        _flipped = flipped;
        
        let beforeKnobRect:NSRect = createBeforeKnobRect();
        let afterKnobRect:NSRect = createAfterKnobRect();
        
        //  Sometimes you can see the ages off you bar
        //  even if your knob is at the end or
        //  at the beginning of it. It's about one pixel
        //  but this help to hide that edges
        if( self.minValue != self.doubleValue ) {
            NSDrawThreePartImage(beforeKnobRect, barLeftAgeImage, barFillBeforeKnobImage, barFillBeforeKnobImage,
                                 false, NSCompositingOperation.sourceOver, 1.0, flipped);
        }
        if( self.maxValue != self.doubleValue ) {
            NSDrawThreePartImage(afterKnobRect, barFillImage, barFillImage, barRightAgeImage,
                                 false, NSCompositingOperation.sourceOver, 1.0, flipped);
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
    
    override func setNeedsDisplay(_ invalidRect: NSRect) {
        super.setNeedsDisplay(invalidRect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if ((self.cell?.isKind(of: MABSliderCell.self)) == false) {
            let cell:MABSliderCell = MABSliderCell()
            self.cell = cell
        }
    }
    
    convenience init(knob:NSImage, barFill:NSImage, barFillBeforeKnob:NSImage, barLeftAge:NSImage, barRightAge:NSImage) {
        self.init()
        self.cell = MABSliderCell(knob: knob, barFill: barFill, barFillBeforeKnob: barFillBeforeKnob, barLeftAge: barLeftAge, barRightAge: barRightAge)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    func knobImage() -> NSImage {
        let cell = self.cell as! MABSliderCell
        return cell.knobImage
    }
    
    func setKnobImage(image:NSImage) {
        let cell = self.cell as! MABSliderCell
        cell.knobImage = image
    }
    
    func barFillImage() -> NSImage {
        let cell = self.cell as! MABSliderCell
        return cell.barFillImage
    }
    
    func setBarFillImage(image:NSImage) {
        let cell = self.cell as! MABSliderCell
        cell.barFillImage = image
    }
    
    func barFillBeforeKnobImage() -> NSImage {
        let cell = self.cell as! MABSliderCell
        return cell.barFillBeforeKnobImage
    }
    
    func setBarFillBeforeKnobImage(image:NSImage) {
        let cell = self.cell as! MABSliderCell
        cell.barFillBeforeKnobImage = image
    }
    
    func barLeftAgeImage() -> NSImage {
        let cell = self.cell as! MABSliderCell
        return cell.barLeftAgeImage
    }
    
    func setBarLeftAgeImage(image:NSImage) {
        let cell = self.cell as! MABSliderCell
        cell.barLeftAgeImage = image
    }
    
    func barRightAgeImage() -> NSImage {
        let cell = self.cell as! MABSliderCell
        return cell.barRightAgeImage
    }
    
    func setBarRightAgeImage(image:NSImage) {
        let cell = self.cell as! MABSliderCell
        cell.barRightAgeImage = image
    }
}



