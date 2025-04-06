public with sharing class TripSelector {
    public static Trip__c getById(Id tripId) {
        try {
            Trip__c trip = [SELECT Id, Name, Status__c FROM Trip__c WHERE Id = :tripId  WITH SECURITY_ENFORCED LIMIT 1];
            if (trip == null) {
                System.debug('Access denied or ou no data available!');
            }
            return trip;
        } catch (SecurityException e) {
            System.debug('Security error : ' + e.getMessage());
            return null;
        }
    }

    public static List<Trip__c> getAll() {
        try {
            List<Trip__c> trips = [SELECT Id, Name, Status__c FROM Trip__c WITH SECURITY_ENFORCED];
            System.debug(trips.isEmpty() ? 'Access denied or ou no data available' : trips.size() + ' voyages found');
            return trips;
        } catch (Exception e) {
            System.debug('Security error : ' + e.getMessage());
            return new List<Trip__c>();
        }
    }
}