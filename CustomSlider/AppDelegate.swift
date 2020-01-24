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


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    
    slider = MABSlider(knob: NSImage(named: "knob")!, barFill: NSImage(named: "fill")!, barFillBeforeKnob: NSImage(named: "beforeknob")!, barLeftAge: NSImage(named: "leftage")!, barRightAge: NSImage(named: "rightage")!);
    slider.frame = NSMakeRect(20, 20, 200, 21);
    slider.action = #selector(AppDelegate.sliderChanged)
    
    slider2.setKnobImage(image: NSImage(named: "knob")!)
    slider2.setBarFillImage(image: NSImage(named: "fill")!)
    slider2.setBarFillBeforeKnobImage(image: NSImage(named: "beforeknob")!)
    slider2.setBarLeftAgeImage(image: NSImage(named: "leftage")!)
    slider2.setBarRightAgeImage(image: NSImage(named: "rightage")!)
    slider2.action = #selector(AppDelegate.slider2Changed)
    
    window.contentView?.addSubview(slider);
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  @objc func sliderChanged() {
    NSLog("\(slider.floatValue)")
  }
  
  @objc func slider2Changed() {
    NSLog("\(slider2.floatValue)")
  }

}

