trigger ContactTrigger on Contact (before insert, before update) {
    Contact oldContacts;
    Account acc;
    

    if(Trigger.IsInsert){
        
        //See if Push_Date__c is declared
        
        
        for(Contact ctc : Trigger.new){
            
            if(ctc.accountId!=null){

                acc = [
                        SELECT PushToVendor__c
                        FROM Account
                        WHERE id =: ctc.accountId];

                if(acc.PushToVendor__c == 'Yes'){
                    List<Contact> accContact = [
                                                SELECT Push_Date__c
                                                FROM Contact
                                                WHERE accountId=: acc.id];
                    ctc.Push_Date__c = accContact[0].Push_Date__c;
                }else{
                    ctc.Push_Date__c = null;
                }
               
            }
                

            }

           

        }
        
        //insert contactToUpdate;
    }
