# Single Touch Rotation Gesture Recognizer
This is a rotation gesture recognizer similar to UIRotationGestureRecognizer but it tracks a single touch as it rotates around the center of the view. You might use it to implement a knob-type control. It is implemented in Swift.

## Usage

Copy SingleTouchRotationGestureRecognizer into your project. It behaves similarly to UIRotationGestureRecognizer. Example:

```
override func viewDidLoad() {
    super.viewDidLoad()
    recognizer = SingleTouchRotationGestureRecognizer(target: self, action: "rotated:")
    square.addGestureRecognizer(recognizer)
}

func rotated(sender: SingleTouchRotationGestureRecognizer) {
    print("rotation: \(sender.rotation)")
    print("velocity: \(sender.velocity)")
}
```

ViewController.swift has some sample code that uses the gesture recognizer to rotate a view in response to touch events.

## License

SingleTouchRotationGestureRecognizer is available under the MIT license. See the LICENSE file for more info.