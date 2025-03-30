public with sharing class TripSelector {
    public static Trip__c getById(Id tripId) {        
        if (!Schema.sObjectType.Trip__c.isAccessible()) {   
            System.debug('Access denied: User does not have permission to view Trip__c.');
            return null;
        }
        return [SELECT Id, Name, Status__c FROM Trip__c WHERE Id = :tripId LIMIT 1];
    }

    public static List<Trip__c> getAll() {
        if (!Schema.sObjectType.Trip__c.isAccessible()) {   
            System.debug('Access denied: User does not have permission to view Trip__c.');
            return new List<Trip__c>();
        }
        return [SELECT Id, Name, Status__c FROM Trip__c];
    }
}