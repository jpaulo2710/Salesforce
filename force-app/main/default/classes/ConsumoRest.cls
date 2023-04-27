@RestResource(urlMapping='/consumo/*')
global class ConsumoRest {
    
    @HttpPost
    global static void create() {
    
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
    
        Consumo__c consumption = (Consumo__c)JSON.deserialize(request.requestBody.toString(), Consumo__c.class);
 
        try {
            
        insert consumption;
            
        response.statusCode = 201;
            
        response.responseBody = Blob.valueOf('Consumo criado com sucesso!');    
        } catch (Exception e) { 
            response.statusCode = 400;
            
        response.responseBody = Blob.valueOf('Erro para criar o consumo: ' + e.getMessage());    

        }
    }
}