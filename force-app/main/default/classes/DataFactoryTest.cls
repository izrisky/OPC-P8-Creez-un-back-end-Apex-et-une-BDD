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
public class DataFactoryTest {

    @testSetup
    static void setupTestData() {
        DataFactory.populateRealisticData(); 
    }

    @isTest
    static void testPopulateRealisticData() {
        
        Test.startTest();
        Integer accountCount = [SELECT COUNT() FROM Account WHERE Name LIKE 'OPC-P8-%'];
        System.assertEquals(10, accountCount, 'Il devrait y avoir 10 comptes.');

        Integer opportunityCount = [SELECT COUNT() FROM Opportunity WHERE Name LIKE 'Contract with %'];
        System.assertEquals(10, opportunityCount, 'Il devrait y avoir 10 opportunités.');

        Integer tripCount = [SELECT COUNT() FROM Trip__c WHERE Status__c = 'A venir'];
        System.assertEquals(10, tripCount, 'Il devrait y avoir 10 voyages.');
        Test.stopTest();
    }

    @isTest
    static void testPopulateRealisticDataForTestBatch() {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'OPC-P8-%'];
        List<Opportunity> opportunities = new List<Opportunity>();

        for (Account acc : accounts) {
            Opportunity opp = new Opportunity(
                Name = 'Opportunity for ' + acc.Name,
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(30),
                AccountId = acc.Id
            );
            opportunities.add(opp);
        }
        insert opportunities;

        Test.startTest();
        DataFactory.populateRealisticDataForTestBatch();
        Test.stopTest();

        Integer newTripCount = [SELECT COUNT() FROM Trip__c];
        System.assert(newTripCount > 0, 'Des voyages devraient être créés.');
    }
}