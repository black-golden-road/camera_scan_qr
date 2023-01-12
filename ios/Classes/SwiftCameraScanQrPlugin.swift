import Flutter
import UIKit

public class SwiftCameraScanQrPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = CameraScanQrFactory(registrar.messenger())
    registrar.register(factory, withId: "plugins.flutter.io/seewo/pinco/camera_scan_qr")
  }
}

public class CameraScanQrFactory: NSObject, FlutterPlatformViewFactory {
    var messenger: FlutterBinaryMessenger
    
    public init(_ messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return CameraScanQrController(withFrame: frame, viewIdentifier: viewId, arguments: args, messenger: self.messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
}

public protocol CameraScanQrDelegate: NSObjectProtocol {
    func onResult(_ result: String)
}

public class NativePreview: UIView {
    public weak var delegate: CameraScanQrDelegate?
    
    public func viewWillAppear() {
    }
    
    public func viewDidDisappear() {
        
    }
    
    public func start() {
        
    }
    
    public func stop() {
        
    }
    
    public func scanImage(path: String) -> String? {
        return nil
    }
}

public class ScanView: UIView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let sublayers = self.layer.sublayers {
            for item in sublayers {
                item.frame = layer.bounds
            }
        }
    }
}

public class CameraScanQrController: NSObject, FlutterPlatformView, CameraScanQrDelegate {
    
    var viewId: Int64
    
    var channel: FlutterMethodChannel
    
    var preview: NativePreview
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        
        self.viewId = viewId
        let channelName = "plugins.flutter.io/seewo/pinco/camera_scan_qr_\(viewId)"
        self.channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        
        self.preview = CameraScanQrView(frame: frame)
        
        super.init()
        
        self.preview.delegate = self
        
        self.channel.setMethodCallHandler { [weak self] call, result in
            DispatchQueue.main.async {
                self?.handle(call, result: result)
            }
        }
    }
    
    public func view() -> UIView {
        return self.preview
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "viewWillAppear":
            self.preview.viewWillAppear()
            result(nil)
        case "viewDidDisappear":
            self.preview.viewDidDisappear()
            result(nil)
        case "start":
            self.preview.start()
            result(nil)
        case "stop":
            self.preview.stop()
            result(nil)
        case "scanImage":
            var qrString: String?
            if let dict = call.arguments as? [String: Any], let path = dict["path"] as? String {
                qrString = self.preview.scanImage(path: path)
            }
            result(qrString)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onResult(_ result: String) {
        self.channel.invokeMethod("onResult", arguments: ["result": result])
    }
    
}



public class CameraScanQrView: NativePreview {
    
    deinit {
        self.stop()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scanView.backgroundColor = UIColor.black
        self.addSubview(self.scanView)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.zoomVideo(_:)))
        self.scanView.addGestureRecognizer(pinch)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.scanView.frame = self.bounds
    }
    
    public override func viewWillAppear() {
        
    }
    
    public override func viewDidDisappear() {
        
    }
    
    private lazy var scanView = ScanView()
    
    private lazy var scanObj: LBXScanWrapper = {
        let scan = LBXScanWrapper(videoPreView: self.scanView,
                                 isCaptureImg: false,
                                 success: { [weak weakSelf = self] (arrayResult) -> Void in
                                     guard let strongSelf = weakSelf else { return }
                                     strongSelf.handleCodeResult(arrayResult: arrayResult)
        })
        return scan
    }()
    
    
    open func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first, let strResult = result.strScanned {
            debugPrint("scan result : \(strResult)")
            return
        }
        self.scanObj.isNeedScanResult = true
    }
    
    private var prevScale: CGFloat = 1.0
    @objc func zoomVideo(_ sender: UIPinchGestureRecognizer) {
        var scale = self.prevScale * sender.scale
        scale = CGFloat.minimum(scale, 3.0)
        scale = CGFloat.maximum(scale, 1.0)
        self.scanObj.zoomCamera(scale)
        
        if (sender.state == .ended || sender.state == .cancelled || sender.state == .failed) {
            self.prevScale = scale;
        }
    }
    
    public override func start() {
        self.scanObj.start()
    }
    
    public override func stop() {
        self.scanObj.stop()
    }
    
    public override func scanImage(path: String) -> String? {
        var qrString: String?
        if let image = UIImage(contentsOfFile: path), let img:CIImage = CIImage.init(image: image) {
            if let qrDetector =  CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])  {
                let reultFeature = qrDetector.features(in: img);
                for feature in reultFeature {
                    if let qrFeature = feature as? CIQRCodeFeature, let result = qrFeature.messageString {
                        qrString = result
                        break
                    }
                }
            }
        }
        return qrString
    }
}
