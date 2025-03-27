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
private class TripServiceTest {

    @testSetup static void setUp() {
        // Créer un enregistrement test pour Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer un voyage de test
        Trip__c trip = new Trip__c(Name = 'Trip Test', Status__c = 'A venir', Account__c = acc.Id);
        insert trip;
    }

    @isTest static void testCreate() {
        // Utiliser un compte existant pour créer un nouveau voyage
        Trip__c trip = new Trip__c(Name = 'New Trip', Status__c = 'A venir', Account__c = [SELECT Id FROM Account LIMIT 1].Id);
        Trip__c result = TripService.create(trip);
        System.assertNotEquals(null, result.Id, 'Le voyage doit être créé');
    }

    @isTest static void testGetById() {
        // Récupérer un voyage de test existant
        Trip__c trip = [SELECT Id, Name FROM Trip__c WHERE Name = 'Trip Test' LIMIT 1];
        Trip__c result = TripService.getById(trip.Id);
        System.assertEquals('Trip Test', result.Name, 'Le nom du voyage doit être "Trip Test"');
    }

    @isTest static void testUpdate() {
        // Utiliser un voyage de test existant et le mettre à jour
        Trip__c trip = [SELECT Id, Status__c FROM Trip__c WHERE Name = 'Trip Test' LIMIT 1];
        trip.Status__c = 'En cours';
        TripService.updateTrip(trip);

        Trip__c updatedTrip = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals('En cours', updatedTrip.Status__c, 'Le statut du voyage doit être mis à jour');
    }

    @isTest static void testDelete() {
        // Utiliser un voyage de test existant et le supprimer
        Trip__c trip = [SELECT Id FROM Trip__c WHERE Name = 'Trip Test' LIMIT 1];
        TripService.deleteTrip(trip.Id);

        List<Trip__c> deletedTrip = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(0, deletedTrip.size(), 'Le voyage doit être supprimé');
    }
}