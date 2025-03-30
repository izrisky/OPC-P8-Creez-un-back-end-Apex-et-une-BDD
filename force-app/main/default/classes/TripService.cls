public with sharing class TripService {
    
    public static Trip__c create(Trip__c trip) {
        if (!Schema.sObjectType.Trip__c.isCreateable()) {   
            System.debug('Access denied: User does not have permission to view Trip__c.');
            return null;
        }
        insert trip;
        return trip;
    }

    public static Trip__c getById(Id tripId) {
        if (!Schema.sObjectType.Trip__c.isAccessible()) {   
            System.debug('Access denied: User does not have permission to view Trip__c.');
            return null;
        }
        return TripSelector.getById(tripId);
    }

    public static void updateTrip(Trip__c trip) {
        if (!Schema.sObjectType.Trip__c.isUpdateable()) {   
            System.debug('Access denied: User does not have permission to view Trip__c.');
        }
        update trip;
    }

    public static void deleteTrip(Id tripId) {
        if (!Schema.sObjectType.Trip__c.isDeletable()) {   
            System.debug('Access denied: User does not have permission to view Trip__c.');
        }
        Trip__c trip = TripSelector.getById(tripId);
        if (trip != null) {
            delete trip;
        }
    }
}