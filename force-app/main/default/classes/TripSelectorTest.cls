/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TripSelectorTest {

    @testSetup static void setUp() {
        // Créer un enregistrement test pour Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer des voyages de test
        Trip__c trip1 = new Trip__c(Name = 'Trip 1', Status__c = 'A venir', Account__c = acc.Id);
        Trip__c trip2 = new Trip__c(Name = 'Trip 2', Status__c = 'A venir', Account__c = acc.Id);
        insert new List<Trip__c>{trip1, trip2};
    }

    @isTest static void testGetById() {
        // Récupérer un voyage de test existant
        Trip__c trip = [SELECT Id, Name FROM Trip__c WHERE Name = 'Trip 1' LIMIT 1];
        Trip__c result = TripSelector.getById(trip.Id);
        System.assertNotEquals(null, result, 'Le voyage doit exister');
        System.assertEquals('Trip 1', result.Name, 'Le nom doit être "Trip 1"');
    }

    @isTest static void testGetAll() {
        // Récupérer tous les voyages de test
        List<Trip__c> trips = TripSelector.getAll();
        System.assertNotEquals(0, trips.size(), 'La liste des voyages ne doit pas être vide');
        
        Boolean foundTrip1 = false;
        Boolean foundTrip2 = false;

        for (Trip__c trip : trips) {
            if (trip.Name == 'Trip 1') foundTrip1 = true;
            if (trip.Name == 'Trip 2') foundTrip2 = true;
        }

        System.assert(foundTrip1, 'Trip 1 devrait être dans la liste');
        System.assert(foundTrip2, 'Trip 2 devrait être dans la liste');
    }
}