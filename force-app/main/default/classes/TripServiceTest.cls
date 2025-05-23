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
    @testSetup 
    static void setUp() {     

        Account account = new Account(Name = 'Test Account');
        insert account;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = account.Id,
            Amount = 1000,
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(15),
            Number_of_Participants__c = 20
        );
        insert opp;

         Trip__c trip = new Trip__c( Status__c = 'A venir', Account__c = account.Id);
        insert trip;
    }

    @isTest 
    static void testCreate() {
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
    @isTest 
    static void testGetById() {
        Trip__c trip = [SELECT Id, Name FROM Trip__c LIMIT 1];
        Test.startTest();
        Trip__c result = TripService.getById(trip.Id);
        Test.stopTest();
        System.assertEquals(trip.Name, result.Name, 'Le nom du voyage doit être "Trip Test"');
    }

    @isTest
     static void testUpdate() {
        Trip__c trip = [SELECT Id, Status__c FROM Trip__c LIMIT 1];
        trip.Status__c = 'En cours';
        Test.startTest();
        TripService.updateTrip(trip);
        Test.stopTest();
        

        Trip__c updatedTrip = [SELECT Status__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals('En cours', updatedTrip.Status__c, 'Le statut du voyage doit être mis à jour');
    }

    @isTest 
    static void testDelete() {
        Trip__c trip = [SELECT Id FROM Trip__c  LIMIT 1];
        Test.startTest();
        TripService.deleteTrip(trip.Id);
        Test.stopTest();
        

        List<Trip__c> deletedTrip = [SELECT Id FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(0, deletedTrip.size(), 'Le voyage doit être supprimé');
    }

    @isTest
    static void testCreateTripForClosedWonOpportunities() {
        Opportunity  opp=[SELECT Id, Name, Amount FROM Opportunity LIMIT 1];
        opp.StageName = 'Closed Won';
    
            Test.startTest();
            update opp;
            Test.stopTest();
    
            List<Trip__c> trips = [SELECT Id, Status__c, Destination__c FROM Trip__c WHERE Opportunity__c = :opp.Id];
            System.assertEquals(1, trips.size());
            System.assertEquals('A venir', trips[0].Status__c);
            System.assertEquals('Paris', trips[0].Destination__c);
    }
    
    @isTest
    static void testTripDateValidation() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];

        Trip__c validTrip = new Trip__c(
            Status__c = 'A venir',
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(15),
            Account__c = account.Id,
            Opportunity__c = opportunity.Id
        );

        Test.startTest();
        insert validTrip; 

        Trip__c invalidTrip = new Trip__c(
            Status__c = 'A venir',
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(15),
            End_Date__c = Date.today().addDays(10),
            Account__c = account.Id,
            Opportunity__c = opportunity.Id
        );

        try {
            insert invalidTrip; 
            System.assert(false, 'La validation des dates a échoué.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de fin doit être postérieure à la date de début.'));
        }
        Test.stopTest();
    }
    @isTest
    static void testDeleteAllTrips() {
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Trip__c trip1 = new Trip__c(
            Status__c = 'A venir',
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(15),
            Account__c = account.Id
        );
        
        Trip__c trip2 = new Trip__c(
            Status__c = 'En cours',
            Start_Date__c = Date.today().addDays(-5),
            End_Date__c = Date.today().addDays(5),
            Account__c = account.Id
        );
        
        insert new List<Trip__c>{trip1, trip2};

        Integer initialCount = [SELECT COUNT() FROM Trip__c];
        System.assertEquals(3, initialCount, 'Il devrait y avoir 2 voyages.');//un trip est ajouté dans setup

        Test.startTest();
        TripService.deleteAllTrips();
        Test.stopTest();

        Integer finalCount = [SELECT COUNT() FROM Trip__c];
        System.assertEquals(0, finalCount, 'Tous les voyages devraient être supprimés.');
    }
}