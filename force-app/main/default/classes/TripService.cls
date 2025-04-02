public with sharing class TripService {
    
    public static Trip__c create(Trip__c trip) {
        if (!Schema.sObjectType.Trip__c.isCreateable()) {   
            System.debug('Access denied: User does not have permission to create Trip__c.');
            return null;
        }
        insert trip;
        return trip;
    }

    public static Trip__c getById(Id tripId) {
        if (!Schema.sObjectType.Trip__c.isAccessible()) {   
            System.debug('Access denied: User does not have permission to read Trip__c.');
            return null;
        }
        return TripSelector.getById(tripId);
    }

    public static void updateTrip(Trip__c trip) {
        if (!Schema.sObjectType.Trip__c.isUpdateable()) {   
            System.debug('Access denied: User does not have permission to update Trip__c.');
        }
        update trip;
    }

    public static void deleteTrip(Id tripId) {
        if (!Schema.sObjectType.Trip__c.isDeletable()) {   
            System.debug('Access denied: User does not have permission to delete Trip__c.');
        }
        Trip__c trip = TripSelector.getById(tripId);
        if (trip != null) {
            delete trip;
        }
    }

    public static void createTripForClosedWonOpportunities(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunityMap) {
        List<Trip__c> tripsToCreate = new List<Trip__c>();

        for(Opportunity opp : newOpportunities) {
            if(opp.StageName == 'Closed Won' && oldOpportunityMap.get(opp.Id).StageName != 'Closed Won') {
                Trip__c newTrip = new Trip__c(
                    //Name = 'Trip ' + opp.Name,
                    Status__c = 'A venir',
                    Destination__c = opp.Destination__c,
                    Start_Date__c = opp.Start_Date__c,
                    End_Date__c = opp.End_Date__c,
                    Number_of_Participants__c = opp.Number_of_Participants__c,
                    Total_Cost__c = opp.Amount,
                    Account__c = opp.AccountId,
                    Opportunity__c = opp.Id
                );
                tripsToCreate.add(newTrip);
            }
        }

        if(!tripsToCreate.isEmpty()) {
            insert tripsToCreate;
        }
    }
    public static void deleteAllTrips() {
        List<Trip__c> trips = [SELECT Id FROM Trip__c];
        
        if (!trips.isEmpty()) {
            try {
                delete trips;
                System.debug('Toutes les trips ont été supprimées.');
            } catch (DmlException e) {
                System.debug('Erreur lors de la suppression des trips : ' + e.getMessage());
            }
        } else {
            System.debug('Aucune trip à supprimer.');
        }
    }
}