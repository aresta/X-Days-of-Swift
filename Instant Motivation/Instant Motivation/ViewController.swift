//
//  ViewController.swift
//  Instant Motivation
//
//  Created by Nash Vail on 02/04/16.
//  Copyright © 2016 Nishant Verma ( Nash Vail ). All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	// MARK: Animation Properties
	var timer = NSTimer()
	var currentFrame = 0
	var isPlaying = false
	
	// MARK: GIF Properties
	var GIFs = [
		GIF(name: "Just Do It", imageNamePrefix: "justdoit_1_frame_", numFrames: 60, fps: 32, audio: AVAudioFile(name: "justdoit", type: "aiff")),
		GIF(name: "Make your dreams come true", imageNamePrefix: "justdoit_2_frame_", numFrames: 62, fps: 26, audio: AVAudioFile(name: "makeyourdreamscometrue", type: "aiff")),
		GIF(name: "Do it", imageNamePrefix: "justdoit_3_frame_", numFrames: 48, fps: 30, audio: AVAudioFile(name: "doit", type:"aiff")),
		GIF(name: "Yes you can", imageNamePrefix: "justdoit_4_frame_", numFrames: 31, fps: 25, audio: AVAudioFile(name: "yesyoucan", type:"aiff"))
	]
	
	var randomGIF: GIF!
	
	// MARK: Audio Properties 
	var audioPlayer: AVAudioPlayer = AVAudioPlayer()
	
	
	// MARK: IB Porperties
	@IBOutlet var motivationImage: UIImageView!
	@IBOutlet var defaultImage: UIImageView!
	@IBOutlet var shakePromptor: CircleView!
	
	// MARK: Overriden methods

	override func viewDidLoad() {
		super.viewDidLoad()
		wobbleShakePromptor()
		let _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewController.wobbleShakePromptor), userInfo: nil, repeats: true)
	}
	

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	// MARK: Custom methods
	
	func initializeRandomGIF() {
		randomGIF = GIFs[randomNumber(0...(GIFs.count-1))]
		initAudioFile(fileName: randomGIF.audio.name, type: randomGIF.audio.type)
	}
	
	func playGIF() {
		isPlaying = true
		hideInitialScreen()
		startGIFAnimation()
		startGIFAudio()
	}
	
	func stopGIF() {
		stopGIFAnimation()
		showInitialScreen()
		isPlaying = false
	}
	
	func startGIFAnimation() -> Void {
		currentFrame = 0
		timer = NSTimer.scheduledTimerWithTimeInterval(1/randomGIF.fps, target: self, selector: #selector(ViewController.animateImage), userInfo: nil, repeats: true)
	}
	
	func stopGIFAnimation() {
		timer.invalidate()
	}
	
	func startGIFAudio() {
		audioPlayer.play()
	}
	
	func animateImage() {
		updateImageToFrame(currentFrame)
		currentFrame += 1
		if currentFrame > randomGIF.numFrames {
			stopGIF()
		}
	}
	
	func updateImageToFrame(frameNumber: Int) {
		let properFrameNumber = frameNumber % randomGIF.numFrames
		motivationImage.image = UIImage(named: "\(randomGIF.imageNamePrefix)\(properFrameNumber).png")
	}

	func hideInitialScreen() {
		fadeOut(defaultImage.layer)
		fadeOut(shakePromptor.layer)
	}
	
	func showInitialScreen() {
		fadeIn(defaultImage.layer)
		fadeIn(shakePromptor.layer)
	}
	
	func randomNumber(range: Range<Int>) -> Int {
		let min = range.startIndex
		let max = range.endIndex
		return Int(arc4random_uniform(UInt32(max - min))) + min
	}
	
	func wobbleShakePromptor() {
		wobble(shakePromptor.layer)
	}
	
	// Initializes the audio file that is to be played
	func initAudioFile(fileName fileName: String, type: String) {
		do {
			try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: type)!))
			audioPlayer.volume = 0.7
		} catch {
			print("There was an error retrieving the file, maybe it doesn't exist")
		}
	}
	
	// MARK: Methods detecting Gestures and shakes
	
	override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
		if event?.subtype == UIEventSubtype.MotionShake{
			if !isPlaying {
				initializeRandomGIF()
				playGIF()
			}
		}
	}
	
	// MARK: Animation methods 
	func fadeOut(layer: CALayer) {
		let fadeOut = CABasicAnimation(keyPath: "opacity")
		fadeOut.fromValue = 1.0
		fadeOut.toValue = 0.0
		fadeOut.duration = 0.3
		fadeOut.fillMode = kCAFillModeForwards
		fadeOut.removedOnCompletion = false
		
		layer.addAnimation(fadeOut, forKey: nil)
	}
	
	func fadeIn(layer: CALayer) {
		let fadeIn = CABasicAnimation(keyPath: "opacity")
		fadeIn.fromValue = 0.0
		fadeIn.toValue = 1.0
		fadeIn.duration = 0.3
		fadeIn.fillMode = kCAFillModeForwards
		fadeIn.removedOnCompletion = false
		
		layer.addAnimation(fadeIn, forKey: nil)
	}
	
	func wobble(layer: CALayer) {
		let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
		wobble.duration = 0.25
		wobble.repeatCount = 4
		wobble.values = [0.0, -M_PI_2/4, 0.0, M_PI_2/4, 0.0]
		wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
		
		layer.addAnimation(wobble, forKey: nil)
	}
	
	
	
	
}

