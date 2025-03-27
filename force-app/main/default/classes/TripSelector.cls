public with sharing class TripSelector {
    public static Trip__c getById(Id tripId) {
        return [SELECT Id, Name, Status__c FROM Trip__c WHERE Id = :tripId LIMIT 1];
    }

    public static List<Trip__c> getAll() {
        return [SELECT Id, Name, Status__c FROM Trip__c];
    }
}