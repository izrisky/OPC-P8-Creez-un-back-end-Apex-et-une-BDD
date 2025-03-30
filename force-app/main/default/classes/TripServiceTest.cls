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
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Trip__c trip = new Trip__c( Status__c = 'A venir', Account__c = acc.Id);
        insert trip;
    }

    @isTest static void testCreate() {
        Trip__c trip = new Trip__c(Status__c = 'A venir', Account__c = [SELECT Id FROM Account LIMIT 1].Id);
        Test.startTest();
        Trip__c result = TripService.create(trip);        
        Test.stopTest();

        System.assertNotEquals(null, result.Id, 'Le voyage doit être créé');
        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Id = :result.Id];
        System.assertEquals(1, trips.size(), 'Un voyage devrait être présent');
    }
    @IsTest
    static void testCreate_WithoutAccess_ShouldReturnNull() {
        User testUser = createUserWithTripReadOnlyAccess();
        if (testUser == null) return;

        Trip__c newTrip =  new Trip__c(Status__c = 'A venir', Account__c = [SELECT Id FROM Account LIMIT 1].Id);
        
        Test.startTest();
        System.runAs(testUser) {
            Trip__c result = TripService.create(newTrip);
            System.assertEquals(null, result, 'Aucun voyage ne devrait être créé');
        }
        Test.stopTest();
    }
    @isTest static void testGetById() {
        Trip__c trip = [SELECT Id, Name FROM Trip__c LIMIT 1];
        Test.startTest();
        Trip__c result = TripService.getById(trip.Id);
        Test.stopTest();
        System.assertEquals(trip.Name, result.Name, 'Le nom du voyage doit être "Trip Test"');
    }

    @isTest static void testUpdate() {
        Trip__c trip = [SELECT Id, Status__c FROM Trip__c LIMIT 1];
        trip.Status__c = 'En cours';
        Test.startTest();
        TripService.updateTrip(trip);
        Test.stopTest();
        

        Trip__c updatedTrip = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals('En cours', updatedTrip.Status__c, 'Le statut du voyage doit être mis à jour');
    }

    @isTest static void testDelete() {
        Trip__c trip = [SELECT Id FROM Trip__c  LIMIT 1];
        Test.startTest();
        TripService.deleteTrip(trip.Id);
        Test.stopTest();
        

        List<Trip__c> deletedTrip = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(0, deletedTrip.size(), 'Le voyage doit être supprimé');
    }

        private static User createUserWithTripReadOnlyAccess() {
            Profile p;
            try {
                p = [SELECT Id FROM Profile WHERE Name = 'Junior Sales Profile' LIMIT 1];
            } catch (Exception e) {
                return null; 
            }
            
            return new User(
                Alias = 'notrip',
                Email = 'notrip@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'NoTripAccess',
                ProfileId = p.Id,
                TimeZoneSidKey = 'Europe/Paris',
                UserName = 'notrip@test.com.' + Math.random(),
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            );
        }
}