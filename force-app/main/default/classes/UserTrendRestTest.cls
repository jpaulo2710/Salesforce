@isTest
private class UserTrendRestTest {
    @isTest
    static void testPost() {
        // Criação de dados de teste
        Account acc = new Account(CPF__c = '07938438026', Name = 'Account Test'); // CPF válido
        insert acc;

        UserTrend__c trend = new UserTrend__c(Account__c = acc.Id, Futebol__c = 1, Filme__c = 2, Carro__c = 3,
                                              Kids__c = 4, Luta__c = 5, BBB__c = 6);
        insert trend;

        String description = 'Futebol';

        // Execução do método de teste
        Test.startTest();
        UserTrend__c updatedTrend = UserTrendRest.post(acc.CPF__c, description);
        Test.stopTest();

        // Verificações de resultado
        System.assertEquals(trend.Id, updatedTrend.Id, 'O ID do objeto UserTrend__c deve ser o mesmo');
        System.assertEquals(trend.Futebol__c + 1, updatedTrend.Futebol__c, 'O campo Futebol__c deve ter sido incrementado em 1');
        System.assertEquals(trend.Filme__c, updatedTrend.Filme__c, 'O campo Filme__c não deve ter sido modificado');
        System.assertEquals(trend.Carro__c, updatedTrend.Carro__c, 'O campo Carro__c não deve ter sido modificado');
        System.assertEquals(trend.Kids__c, updatedTrend.Kids__c, 'O campo Kids__c não deve ter sido modificado');
        System.assertEquals(trend.Luta__c, updatedTrend.Luta__c, 'O campo Luta__c não deve ter sido modificado');
        System.assertEquals(trend.BBB__c, updatedTrend.BBB__c, 'O campo BBB__c não deve ter sido modificado');
    }

     @isTest
    static void testPostWithInvalidDocument() {
        // Criação de dados de teste
        Account acc = new Account(CPF__c = '12345678901', Name = 'Account Test'); // CPF inválido
        insert acc;

        String description = 'Futebol';

        // Execução do método de teste
        Test.startTest();
        try {
            UserTrendRest.post(acc.CPF__c, description);
            System.assert(false, 'Uma exceção deveria ter sido lançada para um documento inválido');
        } catch (QueryException e) {
            // Verificações de resultado
            System.assert(e.getMessage().contains('List has no rows for assignment to SObject'),
                          'Uma exceção "List has no rows for assignment to SObject" deve ter sido lançada');
        }
        Test.stopTest();
    }
}