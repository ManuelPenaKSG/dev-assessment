public virtual class TriggerHandler {

    protected List<Sobject> recordList = Trigger.new;
    private Set<Schema.SObjectField> fields;

    // constructor
    public TriggerHandler(Set<Schema.SObjectField> fields) {
        this.fields = fields;
    }

    /***************************************
     * public instance methods
     ***************************************/

    // main method that will be called during execution
    public void run() {

        // dispatch to the correct handler method
        switch on Trigger.operationType {
            when BEFORE_INSERT {
            }

            when BEFORE_UPDATE {
                for(Sobject sobj : recordList){
                    preventUpdate(sobj);
                }
            }

            when BEFORE_DELETE {

                for(SObject record : trigger.old){
                    preventDeletion(record);
                }
                
                Map<String,List<Sobject>> changedRecords = getChangedRecordsByField(fields);
                onBeforeDelete(changedRecords);

            }

            when AFTER_INSERT {
            }

            when AFTER_UPDATE {
                Map<String,List<Sobject>> changedRecords = getChangedRecordsByField(fields);
                onAfterUpdate(changedRecords);
            }

            when AFTER_DELETE {
            }

            when AFTER_UNDELETE {
            }
        }
    }


    /***************************************
     * context methods
     ***************************************/

    // context-specific methods for override
    @TestVisible
    protected virtual void onBeforeInsert(){}
    @TestVisible
    protected virtual void onBeforeUpdate(Sobject sobj){}
    @TestVisible
    protected virtual void onBeforeDelete(Map<String,List<Sobject>> changedRecords){}
    @TestVisible 
    protected virtual void onAfterInsert(){}
    @TestVisible
    protected virtual void onAfterUpdate(Map<String,List<Sobject>> changedRecords){}
    @TestVisible
    protected virtual void onAfterDelete(){}
    @TestVisible
    protected virtual void onAfterUndelete(){}

    protected virtual void preventDeletion(sObject record){}
    protected virtual void preventUpdate(sObject record){}

    protected Map<String,List<Sobject>> getChangedRecordsByField(Set<Schema.SobjectField> fields){
        Map<String,List<SObject>> changedRecords = new Map<String,List<Sobject>>();
        Map<Id,SObject> oldMap = Trigger.oldMap;

        for(SObject record : recordList){
            Sobject oldRecord = oldMap.get(record.id);

            for(Schema.SobjectField field : fields){
                if(record.get(field) != oldRecord.get(field)){
                    String key = String.valueOf(field);
                    
                    if(changedRecords.containsKey(key)){

                        List<Sobject> records = changedRecords.get(key);
                        changedRecords.put(key,records);

                    }else{
                        changedRecords.put(key, new List<Sobject>{record});
                    }
                }
            }
        }
        return changedRecords;
    }

}
