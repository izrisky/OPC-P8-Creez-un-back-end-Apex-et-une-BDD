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
private class OpportunityServiceTest {

    @testSetup static void setUp() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp1 = new Opportunity(Name = 'Opportunity 1', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acc.Id);
        Opportunity opp2 = new Opportunity(Name = 'Opportunity 2', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acc.Id);
        insert new List<Opportunity>{opp1, opp2};
    }

    @isTest static void testCreate() {
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = [SELECT Id FROM Account LIMIT 1].Id);
        Opportunity result = OpportunityService.create(opp);
        System.assertNotEquals(null, result.Id, 'L\'opportunité doit être créée');
    }

    @isTest static void testGetById() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Opportunity 1' LIMIT 1];
        Opportunity result = OpportunityService.getById(opp.Id);
        System.assertEquals('Opportunity 1', result.Name, 'Le nom de l\'opportunité doit être "Opportunity 1"');
    }

    @isTest static void testUpdate() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity LIMIT 1];
        opp.Name = 'Updated Opportunity';
        OpportunityService.updateOpportunity(opp);

        Opportunity updatedOpp = [SELECT Name FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Updated Opportunity', updatedOpp.Name, 'Le nom de l\'opportunité doit être mis à jour');
    }

    @isTest static void testDelete() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        OpportunityService.deleteOpportunity(opp.Id);

        List<Opportunity> deletedOpp = [SELECT Id FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(0, deletedOpp.size(), 'L\'opportunité doit être supprimée');
    }

    @isTest
    static void testDeleteAllOpportunities() {
        Integer initialCount = [SELECT COUNT() FROM Opportunity];
        System.assertEquals(2, initialCount, 'Il devrait y avoir 2 opportunités.');

        Test.startTest();
        OpportunityService.deleteAllOpportunities();
        Test.stopTest();
        Integer finalCount = [SELECT COUNT() FROM Opportunity];
        System.assertEquals(0, finalCount, 'Toutes les opportunités devraient être supprimées.');
    }
}