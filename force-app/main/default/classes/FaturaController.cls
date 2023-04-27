public without sharing class FaturaController {
    
    public List<Fatura__c> faturaLista {get;set;}
    public List<ContractLineItem> contractLineItems {get;set;}  
    public list <Consumo__c> consumoLista {get;set;}
    public list <ServiceContract> serviceContractList {get;set;}
    
    public FaturaController(ApexPages.StandardController controller) {
        Id faturaId = ApexPages.currentPage().getParameters().get('id');
                
        faturaLista = [SELECT Id, ContaCobranca__r.PrimaryContactId__r.Email, Name, Service_Contract__c, DataEmissao__c, DataVencimento__c, MesReferencia__c, Status__c, TotalPagar__c 
                       FROM Fatura__c WHERE Id = :faturaId];
        
        Fatura__c fatura = faturaLista.get(0);
        
        consumoLista = [SELECT Id, Quantidade__c, Medida__c, DataConsumo__c FROM Consumo__c 
                        WHERE ContractLineItem__c IN(SELECT Id FROM ContractLineItem WHERE ServiceContract.Id =: fatura.Service_Contract__c)
                        AND Data__c =: faturaLista[0].MesReferencia__c];

        contractLineItems = [SELECT Id, Product2.Name, Quantity, UnitPrice, TotalPrice
                             FROM ContractLineItem 
                             WHERE ServiceContract.Id = :fatura.Service_Contract__c];

        serviceContractList = [SELECT Id, ContractNumber FROM ServiceContract WHERE ServiceContract.Id = :fatura.Service_Contract__c];
        
        
    }
    public FaturaController() {
        Id faturaId = ApexPages.currentPage().getParameters().get('id');
        faturaLista = [SELECT Id, ContaCobranca__r.PrimaryContactId__r.Email, Name, Service_Contract__c, DataEmissao__c, DataVencimento__c, MesReferencia__c, Status__c, TotalPagar__c 
                       FROM Fatura__c WHERE Id = :faturaId];
        
        Fatura__c fatura = faturaLista.get(0);
        
        List<ContractLineItem> allContractLineItems = [SELECT Id, Product2.Name, Quantity, UnitPrice, TotalPrice
                                                       FROM ContractLineItem 
                                                       WHERE ServiceContract.Id = :fatura.Service_Contract__c];
        
        
    }
    public void sendEmail() {
        InvoicePDFSender.sendEmail(faturaLista);
    }    
}