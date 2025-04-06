global class UpdateTripStatusBatch implements Database.Batchable<sObject>,Schedulable {    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date today = Date.today();
        return Database.getQueryLocator([
            SELECT Id, Start_Date__c, End_Date__c, Status__c 
            FROM Trip__c 
            WHERE 
                (Status__c = 'A venir' AND Start_Date__c <= :today) OR
                (Status__c = 'En cours' AND End_Date__c < :today) OR
                (Status__c = 'Terminé' AND End_Date__c >= :today)
        ]);
    }    
    global void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        Date today = Date.today();
        for (Trip__c trip : trips) {
            if (today < trip.Start_Date__c) {
                trip.Status__c = 'A venir';
            } else if (today >= trip.Start_Date__c && today <= trip.End_Date__c) {
                trip.Status__c = 'En cours';
            } else if (today > trip.End_Date__c) {
                trip.Status__c = 'Terminé';
            }
        }
        
        update trips;
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext sc) {
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch);
    }
}