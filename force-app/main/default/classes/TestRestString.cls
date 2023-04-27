@RestResource(urlMapping='/helloWorld/*')
global class TestRestString {   
 @HttpPost
  global static void helloWorld(){
      
      String jsonRecebido = RestContext.request.requestbody.toString();
      
      System.debug('' + jsonRecebido);
      
      List<wrapperTest> wrapperList = new List<wrapperTest>();
      wrapperList = (List<wrapperTest>) System.JSON.deserialize(jsonRecebido, List<wrapperTest>.class);
      
      System.debug('numero : ====> ' + wrapperList[1].numero);
      System.debug('dado : ====> ' + wrapperList[1].dado);

  }
}