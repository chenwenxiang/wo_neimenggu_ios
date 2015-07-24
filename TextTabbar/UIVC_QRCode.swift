



import UIKit
import Foundation
import AVFoundation



class UIVC_QRCode: MyViewController ,AVCaptureMetadataOutputObjectsDelegate {
    

    var screen_r = UIScreen.mainScreen().applicationFrame

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var ScanQRCode_str:String?
    
    var return_mode = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        return_mode = 1
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "二维码扫描"
        self.view.backgroundColor = UIColor.grayColor()
        let labIntroudction = UILabel(frame:CGRectMake(15, 100, UIScreen.mainScreen().bounds.size.width-15, 50))
        labIntroudction.backgroundColor = UIColor.clearColor()
        labIntroudction.numberOfLines = 2
        labIntroudction.textColor = UIColor.whiteColor()
        labIntroudction.text = "将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。"
        self.view.addSubview(labIntroudction)
        let imageView = UIImageView(frame:CGRectMake(10, 160, UIScreen.mainScreen().bounds.size.width-20, 300))
        imageView.image = UIImage(named:"pick_bg")
        self.view.addSubview(imageView)
        
    }

    func backClick(){
        
    }
    func turnTorchOn(){
        
    }
    func pickPicture(){
        
    }
    override func viewWillAppear(animated: Bool) {
        
        if return_mode == 100
        {
            self.dismissViewControllerAnimated(true, completion: {})
        }
        
        
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    
    @IBAction func handle_cancal_scan(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    


    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if (error != nil) {
            println(error?.description)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(20,170,UIScreen.mainScreen().bounds.size.width-40,280);
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        var stringValue:String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        println("code is \(stringValue)")
        
//        let alertController = UIAlertController(title: "二维码", message: "扫到的二维码内容为:\(stringValue)", preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alertController, animated: true, completion: nil)
//        var alertView = UIAlertView()
//        alertView.delegate = self
//        alertView.title = "二维码"
//        alertView.message = "扫到的二维码内容为:\(stringValue!)"
//        alertView.addButtonWithTitle("确认")
//        alertView.show()
        
        ScanQRCode_str = stringValue
        
        
        self.performSegueWithIdentifier("Segue_ScanQRCode", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Segue_ScanQRCode"
        {
            var vc = segue.destinationViewController as UIVC_QRCodeList
            vc.QRCode_Str = ScanQRCode_str
        }
    }
    

    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
        println("segue.identifier =\(segue.identifier )")
        if segue.identifier == "Segue_ScanQRCode"
        {
        println("list to code:Segue_ScanQRCode")
        //            var vc = segue.destinationViewController as UIVC_QRCodeList
        //            vc.QRCode_Str = ScanQRCode_str
        }

    }
}

