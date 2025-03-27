public with sharing class TripService {
    
    public static Trip__c create(Trip__c trip) {
        insert trip;
        return trip;
    }

    public static Trip__c getById(Id tripId) {
        return TripSelector.getById(tripId);
    }

    public static Trip__c updateTrip(Trip__c trip) {
        update trip;
        return trip;
    }

    public static void deleteTrip(Id tripId) {
        Trip__c trip = TripSelector.getById(tripId);
        if (trip != null) {
            delete trip;
        }
    }
}