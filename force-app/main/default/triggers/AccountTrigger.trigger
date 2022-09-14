trigger AccountTrigger on Account (after update) {
   
    if(Trigger.IsUpdate){

    
        String pushToVendor;
        Account oldAccount;
        List<Contact> ctc = new List<Contact>();
        List<Contact> contactList = new List<Contact>();
        Set<id> modifyContactDate = new Set<Id>();
        Set<id> notModifyContactDate = new Set<Id>();
        List<Contact> contactsToUpdate = new List<Contact>();
        

        // String pushDateValue = String.valueOf(field);

        for(Account acc : Trigger.new){
            
            ContactUpdateBatch cub = new ContactUpdateBatch(acc.id);

            contactList = [
                            SELECT Id
                            FROM Contact
                            WHERE accountId =: acc.id];

           

            oldAccount = Trigger.oldMap.get(acc.Id);
            pushToVendor = acc.PushToVendor__c;

            if(oldAccount.PushToVendor__c != acc.PushToVendor__c){
                switch on pushToVendor {
                    when 'Yes' {
                        
                        if(contactList.size()>1000){
                            Database.executeBatch(cub,150);
                        }else{
                            modifyContactDate.add(acc.Id);
                        }
                    }
                    when 'No' {
                       
                            notModifyContactDate.add(acc.Id);
                       
                    }
                    when else{
                    }
                }
            }

        }

        if(modifyContactDate.size()>0){
            ctc = [
            SELECT Push_Date__c
            FROM Contact
            WHERE AccountId IN : modifyContactDate];
            contactsToUpdate = contactToUpdate(ctc,true);
            
        }
       
        if(notModifyContactDate.size()>0){
            ctc = [
            SELECT Push_Date__c
            FROM Contact
            WHERE AccountId IN : notModifyContactDate];
            contactsToUpdate.addAll(contactToUpdate(ctc,false));
        }
        update contactsToUpdate;     
    }

    private List<contact> contactToUpdate(List<Contact> contacts, Boolean Flag){

        List<Contact> contactToUpdate = new List<Contact>();
       
        if(flag){
            for(Contact ctcToUpdate : contacts){
                ctcToUpdate.Push_Date__c = Date.today();
                contactToUpdate.add(ctcToUpdate);
            }
            return contactToUpdate;
        }else{
            for(Contact ctcToUpdate : contacts){
                ctcToUpdate.Push_Date__c = null;
                contactToUpdate.add(ctcToUpdate);
            }
            return contactToUpdate;
        }
        
    }
}