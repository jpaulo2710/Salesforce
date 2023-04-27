public class EmailSender {
    public void sendEmail(Blob attachment, String recipient,String subject, String body) {
        List<Blob> attachments = new List<Blob>{ attachment };
                
        Messaging.SingleEmailMessage email = createEmail(attachments, recipient, subject, body);
                
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
    }
    
    public void sendEmail(List<Blob> blobs, String recipient, String subject, String body) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage email = this.createEmail(blobs, recipient, subject, body);
            
        emails.add(email);
      	Messaging.sendEmail(emails);                    
    }
    
    private Messaging.SingleEmailMessage createEmail(List<Blob> blobs, String emailAddress, String subject, String body) {        
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        
        email.setSubject(subject);
        email.setHtmlBody(body);
        
        email.setToAddresses( new List<String>{ emailAddress } );
        
        email.setFileAttachments( this.createFileAttachment(blobs) );
        
        return email;
    }
    
    private List<Messaging.Emailfileattachment> createFileAttachment(List<Blob> blobs) {
        
        List<Messaging.Emailfileattachment> attachments = new List<Messaging.Emailfileattachment>();
        
        for(Blob att : blobs) {
            Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
            
            fileAttachment.setFileName('attachment.pdf');
            
            fileAttachment.setBody(att);

			attachments.add(fileAttachment);            
        }
        
        return attachments;
    }
    
}