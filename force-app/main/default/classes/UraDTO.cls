global class UraDTO {
    
    public String message{get;set;}
    
    public String nextMenu{get;set;}
    
    public String previousMenu{get;set;}
    
    public String caseId{get;set;}
    
    public String accountId{get;set;}    
    
    public List<Option> options{get;set;}
    
    public UraDTO() {
        this.options = new List<UraDTO.Option>();
    }
    
    public void addOption(String selection, String description) {
        this.options.add(new UraDTO.Option(selection, description));
    }
    
    public class Option {
        
        public String selection{get;set;}
        public String description{get;set;}
        
        public Option(String selection, String description) {
            this.selection = selection;
            this.description = description;
        }
    }
}