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
public class UpdateTripStatusBatchTest {
    @isTest
    static void testTripStatusUpdate() {
        // Créer un compte pour associer aux voyages
        Account account = new Account(Name = 'Test Account');
        insert account;
        Date futureDate = Date.today().addDays(5);
        Date passedDate1 = Date.today().addDays(-2);
        Date passedDate2 = Date.today().addDays(-10);

        // Créer des voyages avec différentes dates pour tester les différents statuts
        Trip__c trip1 = new Trip__c(
            Status__c = 'A venir',
            Start_Date__c = futureDate,
            End_Date__c = Date.today().addDays(10),
            Account__c = account.Id
        );

        Trip__c trip2 = new Trip__c(
            Status__c = 'En cours',
            Start_Date__c = passedDate1,
            End_Date__c = Date.today().addDays(3),
            Account__c = account.Id
        );

        Trip__c trip3 = new Trip__c(
            Status__c = 'Terminé',
            Start_Date__c = passedDate2,
            End_Date__c = Date.today().addDays(-5),
            Account__c = account.Id
        );

        insert new List<Trip__c>{trip1, trip2, trip3};

        // Démarrer le test
        Test.startTest();
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Vérifier les statuts mis à jour
        Trip__c updatedTrip1 = [SELECT Status__c FROM Trip__c WHERE Start_Date__c = :futureDate];
        Trip__c updatedTrip2 = [SELECT Status__c FROM Trip__c WHERE Start_Date__c = :passedDate1];
        Trip__c updatedTrip3 = [SELECT Status__c FROM Trip__c WHERE Start_Date__c = :passedDate2];

        // Vérifier les résultats attendus
        System.assertEquals('A venir', updatedTrip1.Status__c);
        System.assertEquals('En cours', updatedTrip2.Status__c);
        System.assertEquals('Terminé', updatedTrip3.Status__c);
    }
}