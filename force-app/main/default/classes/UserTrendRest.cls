@RestResource(urlMapping='/trend/*')
global class UserTrendRest {
    
    @HttpPut
    global static UserTrend__c post(String document, String description) {
        Account acc;
        
        if(document.length() == 11) {
            acc = [SELECT Id FROM Account WHERE CPF__c =: document];
        } else {
            acc = [SELECT Id FROM Account WHERE CNPJ__c =: document];
        }
        UserTrend__c trend = [SELECT Id, Futebol__c , Filme__c, Carro__c, Kids__c, Luta__c, BBB__c
                              FROM UserTrend__c WHERE Account__c =: acc.Id];
        Switch on description {
            when 'Futebol' {
                ++trend.Futebol__c;
            }
                when 'Carro' {
                ++trend.Carro__c;
            }
                when 'Filme' {
                ++trend.Filme__c;
            }
                when 'Kids' {
                ++trend.Kids__c;
            }
                when 'Luta' {
                ++trend.Luta__c;
            }
                when 'BBB' {
                ++trend.BBB__c;
            }
        }
        update trend;
        return trend;
    }
    
}