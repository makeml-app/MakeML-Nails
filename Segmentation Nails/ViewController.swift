//
//  ViewController.swift
//  Segmentation Nails
//
//  Created by Alexey Korotkov on 8/26/19.
//  Copyright © 2019 Alexey Korotkov. All rights reserved.
//

import UIKit

import Foundation
import AVFoundation
import CoreVideo
import CoreGraphics

enum PixelError: Error {
    case canNotSetupAVSession
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var preView: UIView!
    var model: DeepLabModel!
    var session: AVCaptureSession!
    var videoDataOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var maskView: UIView!
    var selectedDevice: AVCaptureDevice?
    let colors: [UIColor] = [UIColor.uiColorFromHex(rgbValue: 0xF47E2D, alpha: 0.8),
                             UIColor.uiColorFromHex(rgbValue: 0x750708, alpha: 0.8),
                             UIColor.uiColorFromHex(rgbValue: 0x004B8C, alpha: 0.8),
                             UIColor.uiColorFromHex(rgbValue: 0xFFC621, alpha: 0.8),
                             UIColor.uiColorFromHex(rgbValue: 0xCD1041, alpha: 0.8)]
    var selectedColor = UIColor()
    
    static let imageEdgeSize = 257
    static let rgbaComponentsCount = 4
    static let rgbComponentsCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedColor = colors[0]
        model = DeepLabModel()
        let result = model.load()
        if (result == false) {
            fatalError("Can't load model.")
        }
        
        do {
            try setupAVCapture(position: .back)
        } catch {
            print(error)
        }
        
        collectionView.register(CameraCollectionViewCell.self,
                                forCellWithReuseIdentifier: CameraCollectionViewCell.identifier)
        collectionView.register(ColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
    }
    
    func toggleCamera() {
        guard let selectedDevice = selectedDevice else {
            try? self.setupAVCapture(position: .front)
            return
        }
        
        if selectedDevice.position == .front {
            try? self.setupAVCapture(position: .back)
        } else {
            try? self.setupAVCapture(position: .front)
        }
    }
    
    // Setup AVCapture session and AVCaptureDevice.
    func setupAVCapture(position: AVCaptureDevice.Position) throws {
        
        if let existedSession = session, existedSession.isRunning {
            existedSession.stopRunning()
        }
        
        session = AVCaptureSession()
        session.sessionPreset = .hd1280x720
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position) else {
            throw PixelError.canNotSetupAVSession
        }
        selectedDevice = device
        let deviceInput = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(deviceInput) else {
            throw PixelError.canNotSetupAVSession
        }
        session.addInput(deviceInput)
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        guard session.canAddOutput(videoDataOutput) else {
            throw PixelError.canNotSetupAVSession
        }
        session.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video) else {
            throw PixelError.canNotSetupAVSession
        }
        
        connection.isEnabled = true
        preparePreviewLayer(for: session)
        session.startRunning()
    }
    
    // Setup preview screen.
    func preparePreviewLayer(for session: AVCaptureSession) {
        guard previewLayer == nil else {
            previewLayer.session = session
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.videoGravity = .resizeAspect
        
        preView.layer.addSublayer(previewLayer)
        
        
        maskView = UIView()
        preView.addSubview(maskView)
        preView.bringSubviewToFront(maskView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        maskView.frame = preView.bounds
        previewLayer.frame = preView.bounds
    }
    
    // Receive result from a model.
    func processFrame(pixelBuffer: CVPixelBuffer) {
        let convertedColor = UInt32(selectedColor.switchBlueToRed()!)
        let result: UnsafeMutablePointer<UInt8> = model.process(pixelBuffer, additionalColor: convertedColor)
        let buffer = UnsafeMutableRawPointer(result)
        DispatchQueue.main.async {
            self.draw(buffer: buffer, size: ViewController.imageEdgeSize*ViewController.imageEdgeSize*ViewController.rgbaComponentsCount)
        }
    }
    
    // Overlay over camera screen.
    func draw(buffer: UnsafeMutableRawPointer, size: Int) {
        let callback:CGDataProviderReleaseDataCallback  = { (pointer: UnsafeMutableRawPointer?, rawPointer: UnsafeRawPointer, size: Int) in }
        
        let width = ViewController.imageEdgeSize
        let height = ViewController.imageEdgeSize
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let bytesPerRow = ViewController.rgbaComponentsCount * width
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageByteOrderInfo.orderDefault.rawValue).union(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue))
        
        let renderingIntent: CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent
        guard let provider = CGDataProvider(dataInfo: nil,
                                            data: buffer,
                                            size: size,
                                            releaseData: callback) else { return }
        
        guard let cgImage = CGImage(width: width,
                                    height: height,
                                    bitsPerComponent: bitsPerComponent,
                                    bitsPerPixel: bitsPerPixel,
                                    bytesPerRow: bytesPerRow,
                                    space: colorSpace,
                                    bitmapInfo: bitmapInfo,
                                    provider: provider,
                                    decode: nil,
                                    shouldInterpolate: false,
                                    intent: renderingIntent) else { return }
        if let device = selectedDevice, device.position == .front {
            maskView.layer.contents = cgImage
            return
        }
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        transform = transform.translatedBy(x: CGFloat(width), y: 0)
        transform = transform.scaledBy(x: -1.0, y: 1.0)
        
        context.concatenate(transform)
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        maskView.layer.contents = context.makeImage()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            processFrame(pixelBuffer: pixelBuffer)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraCollectionViewCell.identifier,
                                                          for: indexPath)
            return cell
        } else {
            let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier,
                                                      for: indexPath) as! ColorCollectionViewCell
            colorCell.backgroundColor = colors[indexPath.row - 1]
            return colorCell
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            toggleCamera()
        } else {
            selectedColor = colors[indexPath.row - 1]
        }
    }
}

