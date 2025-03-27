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
private class OpportunitySelectorTest {

    @testSetup static void setUp() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp1 = new Opportunity(Name = 'Opportunity 1', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acc.Id);
        Opportunity opp2 = new Opportunity(Name = 'Opportunity 2', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acc.Id);
        insert new List<Opportunity>{opp1, opp2};
    }

    @isTest static void testGetById() {
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Opportunity 1' LIMIT 1];
        Opportunity result = OpportunitySelector.getById(opp.Id);
        System.assertNotEquals(null, result, 'L\'opportunité doit exister');
        System.assertEquals('Opportunity 1', result.Name, 'Le nom doit être "Opportunity 1"');
    }

    @isTest static void testGetAll() {
        List<Opportunity> opportunities = OpportunitySelector.getAll();
        System.assertNotEquals(0, opportunities.size(), 'La liste des opportunités ne doit pas être vide');
        
        Boolean foundOpp1 = false;
        Boolean foundOpp2 = false;

        for (Opportunity opp : opportunities) {
            if (opp.Name == 'Opportunity 1') foundOpp1 = true;
            if (opp.Name == 'Opportunity 2') foundOpp2 = true;
        }

        System.assert(foundOpp1, 'Opportunity 1 devrait être dans la liste');
        System.assert(foundOpp2, 'Opportunity 2 devrait être dans la liste');
    }
}