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
public class CancelTripsBatchTest {
    @isTest
    static void testBatchExecution() {
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        for (Integer i = 0; i < 5; i++) {
            Trip__c trip = new Trip__c(
                Status__c = 'A venir',
                Number_of_Participants__c = i,
                Start_Date__c = Date.today().addDays(7),
                Account__c = account.Id
            );
            insert trip;
        }
        Test.startTest();
        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Vérifier que les voyages ont été annulés
        List<Trip__c> trips = [SELECT Status__c , Number_of_Participants__c FROM Trip__c WHERE Account__c=: account.Id];
        for (Trip__c trip : trips) {
            if (trip.Number_of_Participants__c < 10) {
                System.assertEquals('Annulé', trip.Status__c);
            }
        }
    }
}