public with sharing class AccountController {
    public AccountController() {

    }
    
    // @AuraEnabled(cacheable=true)
    // public static List<Contact> displayContacts(string accId){
    //     return [Select Name, Email, Phone,Photo_Link__c From Contact where AccountId =: accId];
    // }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccountsOnSearch(String searchKey,String accId){ 
         List<Contact> Result;
       
                Result = [Select Name,Title,Email, Phone,Profile_Picture__c From Contact Where Name LIKE : '%' + searchKey + '%' AND AccountId =: accId];

        
        return Result;
    }
}
