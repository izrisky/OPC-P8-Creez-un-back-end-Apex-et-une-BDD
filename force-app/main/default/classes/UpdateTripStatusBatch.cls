global class UpdateTripStatusBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Start_Date__c, End_Date__c, Status__c 
            FROM Trip__c 
            WHERE Status__c IN ('A venir', 'En cours', 'Terminé')
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
}