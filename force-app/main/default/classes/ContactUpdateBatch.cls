global class ContactUpdateBatch implements Database.Batchable<sObject>{

    private Id accId;

    public ContactUpdateBatch(Id accIdParam){
        accId = accIdParam;
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Push_Date__c FROM Contact WHERE accountId =: accId ]);
    }

    global void execute(Database.BatchableContext bc, List<contact> ContactList){
        for(Contact ctc : ContactList){
            ctc.Push_Date__c = Date.today();
        }
    }

    global void finish(Database.BatchableContext bc){

    }
}
