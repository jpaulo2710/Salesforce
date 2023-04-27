@RestResource(urlMapping='/ura/*')
global without sharing class UraController {
    
    @HttpPost()
    global static UraDTO init() {        
        String document = RestContext.request.params.get('document');
        String option = RestContext.request.params.get('option');
        String menu = RestContext.request.params.get('menu');
        String caseId = RestContext.request.params.get('caseId');
        String accountId = RestContext.request.params.get('accountId');
        
        if(menu == null) { 
            return welcome(); 
        } 
        else if(menu == 'start') {
            return start(option);
        } 
        else if(menu == 'document') {
            return document(document);
        }
        else if(menu == 'attendance') {
            return attendance(option, accountId);
        } 
        else if(menu == 'invoice') {
            return invoice(option, caseId, accountId);
        }
        
        return new UraDTO();
    }
    
    public static UraDTO welcome() {
        UraDTO dto = new UraDTO();
        
        dto.message = 'Seja bem-vindo a central de atendimento ATT';   
        dto.nextMenu = 'start';
        
        dto.addOption('1', 'Se já for cliente.');        
        dto.addOption('2', 'Se tem interesse em tornar-se.');
        
        return dto;
    }
    
    public static UraDTO start(String option) {
        UraDTO dto = new UraDTO();
        dto.previousMenu = 'welcome';

        if(option.equals('1')) {
            dto.message = 'Insira seu CPF para continuar:';
            dto.nextMenu = 'document';    
        } else {
            dto.message = 'Procure uma loja fisica';               
        }
        
        return dto;        
    }
    
    public static UraDTO document(String document) {
        Account acc;
        UraDTO dto = new UraDTO();
        dto.previousMenu = 'start';
        
        if(document.length() == 11) {
            acc = [SELECT Id, Name, PrimaryContactId__c FROM Account WHERE CPF__c =: document];
        } else {
            acc = [SELECT Id, Name, PrimaryContactId__c FROM Account WHERE CNPJ__c =: document];                    
        }        
        
        if(acc != null) {
            dto.nextMenu = 'attendance';
            dto.previousMenu = 'start';
            dto.accountId = acc.Id;         
            dto.message = 'Olá,' + acc.Name + ' Como podemos te ajudar hoje?';
            
            dto.addOption('1', 'Fatura');            
            dto.addOption('2', 'Franquia');
            dto.addOption('3', 'Novo Contrato');
        } else {
            dto.message = 'O documento inserido não existe, tente novamente.';
            dto.nextMenu = 'document';            
        }
        return dto;        
    }
    
    public static UraDTO attendance(String option, String accountId) {
        UraDTO dto = new UraDTO();
        dto.previousMenu = 'document';
        dto.accountId = accountId;
        
        if(option.equals('1')) {
            dto.message = 'Você selecionou a opção faturas, como deseja prosseguir?';

            dto.addOption('1', 'Segunda via de fatura');
            dto.addOption('2', 'Atendimento financeiro');
        }
        
        else if(option.equals('2')) {

            Case caseObj = new Case();
            caseObj.AccountId = accountId;
            caseObj.Status = 'New';
            caseObj.Origin = 'Phone';
            caseObj.RecordTypeId = '012Dn000001nZyRIAU'; //startSuporteCase
            caseObj.Reason = 'Support';
            insert caseObj;
            dto.caseId = caseObj.Id;

            caseObj.Status = 'Closed';
            update caseObj;

            List<Consumo__c> lista = [SELECT Id, Quantidade__c FROM Consumo__c 
                                              WHERE DataConsumo__c = THIS_MONTH
                                              AND AccountId__c =: accountId];
            
            Double consumoTotal = 0;
            
            for(Consumo__c data: lista){
                consumoTotal += data.Quantidade__c;
            }
            
            dto.message = 'Você consumiu ' + consumoTotal + ' MB de franquia no mês atual.';
            
        } else if(option.equals('3')){
            Case caseObj = new Case();
            caseObj.AccountId = accountId;
            caseObj.Status = 'New';
            caseObj.Origin = 'Phone';
            caseObj.RecordTypeId = '012Dn000001nH0DIAU'; //startComercialCase
            caseObj.Reason = 'Upgrade';
            insert caseObj;
            dto.caseId = caseObj.Id;

            dto.message = 'Foi aberto um chamado e em breve um atendente irá retornar o contato.';
        }
        else  {
            dto.message = 'Procure uma loja fisica';               
        }
        return dto;
    }
    
    public static UraDTO invoice(String option, String caseId, String accountId) {
        UraDTO dto = new UraDTO();
        dto.previousMenu = 'attendance';
        dto.caseId = caseId;
        dto.accountId = accountId;
        
        if(option.equals('1')) {
            List<Fatura__c> invoices = [SELECT Id, ContaCobranca__r.PrimaryContactId__r.Email, Name, Service_Contract__c, DataEmissao__c, DataVencimento__c, MesReferencia__c, Status__c, TotalPagar__c  FROM Fatura__c WHERE ContaCobranca__c =: accountId AND Pago__c =: false];
            
            InvoicePDFSender.sendEmail(invoices);

            Case caseObj = new Case();
            caseObj.AccountId = accountId;
            caseObj.Status = 'New';
            caseObj.Origin = 'Phone';
            caseObj.RecordTypeId = '012Dn000001nZxsIAE'; //startAtendimentoFaturaCase
            caseObj.Reason = 'Fatura';
            insert caseObj;
            dto.caseId = caseObj.Id;

            caseObj.Status = 'Closed';
            update caseObj;
            
            dto.message = 'Você selecionou a opção segunda via de faturas, voce tem ' + invoices.size() + ' fatura(s) pendente(s), registro(s) enviado(s) para o email cadastrado';
        }
        else if(option.equals('2')) {
            Case caseObj = new Case();
            caseObj.AccountId = accountId;
            caseObj.Status = 'New';
            caseObj.Origin = 'Phone';
            caseObj.RecordTypeId = '012Dn000001nZyMIAU'; //startComercialCase
            caseObj.Reason = 'Atendimento Financeiro';
            insert caseObj;
            dto.caseId = caseObj.Id;

            dto.message = 'Foi aberto um chamado e em breve um atendente retornará o contato';
        }
        return dto;
    }
    
}