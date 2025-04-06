global class CancelTripsBatch implements Database.Batchable<sObject> ,Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Number_of_Participants__c 
            FROM Trip__c 
            WHERE Start_Date__c = :Date.today().addDays(7)
            AND Number_of_Participants__c < 10
            AND Number_of_Participants__c != null
            AND Status__c != 'Annulé'
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            trip.Status__c = 'Annulé';
        }
        
        update trips;
    }
    //to schedule
    global void execute(SchedulableContext sc) {
        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch);
    }
    global void finish(Database.BatchableContext BC) {
    }
}