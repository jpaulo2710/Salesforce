public class InvoicePDFSender {
    
    @InvocableMethod(label='Send InvoicePDF')
    public static void sendEmail(List<Fatura__c> invoiceIn) {
        List<Blob> attachments = new List<Blob>();
                
        for(Fatura__c invoice : invoiceIn) {
            attachments.add(createPDF(invoice.Id));
        }
        
        String contactEmail = invoiceIn.get(0).ContaCobranca__r.PrimaryContactId__r.Email;
        
        String body = 'Prezado(a) cliente, Segue em anexo a sua fatura.<br/>Caso tenha alguma dúvida ou precise de suporte, nossa equipe está à disposição para ajudá-lo(a).';
        String subject = 'Fatura AT&T';
        
        EmailSender sender = new EmailSender();
        sender.sendEmail(attachments, contactEmail, subject, body);
    }
    
    private static Blob createPDF(String invoiceId) {
        PageReference page = new PageReference('/apex/ClienteFaturaGerarPDF');
        page.getParameters().put('id', InvoiceId);
        page.setRedirect(true);
        
        return page.getContentAsPDF();
    }   
       
}