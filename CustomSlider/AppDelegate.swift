//
//  AppDelegate.swift
//  CustomSlider
//
//  Created by Muhammad Bassio on 11/19/14.
//  Copyright (c) 2014 Muhammad Bassio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var slider:MABSlider!
  @IBOutlet var slider2: MABSlider!


  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
    
    slider = MABSlider(knob: NSImage(named: "knob")!, barFill: NSImage(named: "fill")!, barFillBeforeKnob: NSImage(named: "beforeknob")!, barLeftAge: NSImage(named: "leftage")!, barRightAge: NSImage(named: "rightage")!);
    slider.frame = NSMakeRect(20, 20, 200, 21);
    slider.action = "sliderChanged"
    
    slider2.setKnobImage(NSImage(named: "knob")!)
    slider2.setBarFillImage(NSImage(named: "fill")!)
    slider2.setBarFillBeforeKnobImage(NSImage(named: "beforeknob")!)
    slider2.setBarLeftAgeImage(NSImage(named: "leftage")!)
    slider2.setBarRightAgeImage(NSImage(named: "rightage")!)
    slider2.action = "slider2Changed"
    
    window.contentView?.addSubview(slider);
    
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }
  
  func sliderChanged() {
    NSLog("\(slider.floatValue)")
  }
  
  func slider2Changed() {
    NSLog("\(slider2.floatValue)")
  }

}

