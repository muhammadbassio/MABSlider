MABSlider (swift)
=================

A customized slider for OSX using png images written in swift.

## ScreenShot

![MABSlider](/SS.png)

## Install
- Drag "MABNSSLider.swift" to your Xcode project. 

## Using Interface Builder
- Add an NSSlider to your view.
- Edit the class name to be "MABSlider" instead of "NSSlider".
- Edit your appdelegate as below:

```
@IBOutlet var slider2: MABSlider!

func applicationDidFinishLaunching(aNotification: NSNotification) {
    
    slider2.setKnobImage(NSImage(named: "knob")!)
    slider2.setBarFillImage(NSImage(named: "fill")!)
    slider2.setBarFillBeforeKnobImage(NSImage(named: "beforeknob")!)
    slider2.setBarLeftAgeImage(NSImage(named: "leftage")!)
    slider2.setBarRightAgeImage(NSImage(named: "rightage")!)
    slider2.action = "slider2Changed"
    
    window.contentView?.addSubview(slider);
    
  }
  
  func slider2Changed() {
    // your code goes here
    NSLog("\(slider2.floatValue)")
  }

```

## Using Code

Edit your appdelegate as below:

```
var slider:MABSlider!


  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
    
    slider = MABSlider(knob: NSImage(named: "knob")!, barFill: NSImage(named: "fill")!, barFillBeforeKnob: NSImage(named: "beforeknob")!, barLeftAge: NSImage(named: "leftage")!, barRightAge: NSImage(named: "rightage")!);
    slider.frame = NSMakeRect(20, 20, 200, 21);
    slider.action = "sliderChanged"
    
    window.contentView?.addSubview(slider);
    
  }
  
  func sliderChanged() {
    // your code goes here 
    NSLog("\(slider.floatValue)")
  }
  
```

##License

MIT License (MIT)

```
Copyright (c) 2014 MuhammadBassio

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

<<<<<<< HEAD
```
=======
```
>>>>>>> FETCH_HEAD
