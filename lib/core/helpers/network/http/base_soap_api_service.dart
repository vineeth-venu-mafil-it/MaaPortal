abstract class BaseSoapApiServices {
  Future<dynamic> postSoapRequest(String url,String soapBody);
  Future<dynamic> getSoapRequest(String url);
}