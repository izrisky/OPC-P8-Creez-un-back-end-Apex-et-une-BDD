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
   @testSetup
    static void setUp() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Trip__c trip1 = new Trip__c(Status__c = 'A venir', Account__c = acc.Id);
        Trip__c trip2 = new Trip__c(Status__c = 'A venir', Account__c = acc.Id);
        insert new List<Trip__c>{trip1, trip2};
    }
    
    @isTest
    static void testGetById() {
        Trip__c trip  = [SELECT Id, Name FROM Trip__c  LIMIT 1];
        Test.startTest();
        Trip__c result = TripSelector.getById(trip.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Le voyage doit exister');
        System.assertEquals(trip.Name, result.Name, 'Le nom doit être :'+trip.Name);
    }
    @isTest
    static void testGetById_WithoutAccess() {       
         User testUser = createUserWithoutTripAccess();
        if (testUser == null) return;
        Trip__c trip  = [SELECT Id, Name FROM Trip__c  LIMIT 1];

        Test.startTest();
        System.runAs(testUser) {            
    try {
            Trip__c result = TripSelector.getById(trip.Id);
            System.assertEquals(null, result, 'Le voyage doit être null');
        } catch (Exception e) {
            System.assert(e instanceof QueryException, 'Doit lever une QueryException en cas de champ inaccessibles');
        }
        }
        Test.stopTest();
    }
    @isTest 
    static void testGetAll() {
        Test.startTest();
        List<Trip__c> trips = TripSelector.getAll();
        Test.stopTest();
        System.assertNotEquals(0, trips.size(), 'La liste des voyages ne doit pas être vide');
        System.assertEquals(2, trips.size(), 'La liste des voyages doit contenir 2 entrées');
    }
    @isTest
    static void testGetAll_WithoutAccess() {       
         User testUser = createUserWithoutTripAccess();
        if (testUser == null) return;
        Trip__c trip  = [SELECT Id, Name FROM Trip__c  LIMIT 1];

        Test.startTest();
        System.runAs(testUser) {
            List<Trip__c> trips = TripSelector.getAll();
            System.assertEquals(0, trips.size(), 'La liste des voyages doit être vide');
        }
        Test.stopTest();
    }
    // Méthode utilitaire pour créer un utilisateur sans droits sur Trip__c
    private static User createUserWithoutTripAccess() {
        Profile p;
        try {
            p = [SELECT Id FROM Profile WHERE Name = 'Minimum Access - Salesforce' LIMIT 1];
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