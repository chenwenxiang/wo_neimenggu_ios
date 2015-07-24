


///民族情



import UIKit

class UIVC_EthnicBuy:  UIViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        call_server()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
    
    
    
    let serverUrl = "http://116.113.88.50:81/PosWebService.ASMX?WSDL";
    //请求发送到的路径
    let soapActionURL = "http://tempuri.org/WSQuery_MoreMzq";
    let action = "WSQuery_MoreMzq"
    
    
    
    func  call_server()
    {
    //封装soap请求消息
    
   /* var  soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<WSQuery_MoreMzq xmlns=\"http://tempuri.org/\">\n"
    "<Page>1</Page>\n"
    "<MaxPerPage>20</MaxPerPage>\n"
    "</WSQuery_MoreMzq>\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n";
        
        
        var requestDic = NSDictionary(objects: ["Page","MaxPerPage"], forKeys: ["1","20"]);
        
        //{"Page":"1","MaxPerPage":"20"}
    var jsonreq = buildParam(requestDic)
        
        var theXML = invokeWebService(jsonreq, soapMessage)
        
        println("theXML="+theXML)*/
    
    
//        var request : NetWebServiceRequestDelegate = NetWebServiceRequestDelegate( NetWebServiceRequest.serviceRequestUrl(serverUrl, SOAPActionURL: soapActionURL, serviceMethodName: action, soapMessage: soapMessage))
//        
       // var reqqq = NetWebServiceRequestDelegate(AnyObject(request))
    
       // self.run
    
//    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"WSQuery_MoreMzq" SoapMessage:soapMessage];
//    
//    [request startAsynchronous];
//    [request setDelegate:self];
//    self.runningRequest = request;
     
    
    
    }
    
    
//    func netRequestStarted(request: NetWebServiceRequest!) {
//        
//    }
//
//    func netRequestFinished(request: NetWebServiceRequest!, finishedInfoToResult result: String!, responseData requestData: NSData!) {
//        
//    }
//    
//    func netRequestFailed(request: NetWebServiceRequest!, didRequestError error: NSError!) {
//        
//    }
}
