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
private class ContractServiceTest {

    @testSetup static void setUp() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contract con = new Contract(AccountId = acc.Id, Status = 'Draft');
        insert con;
    }

    @isTest static void testCreate() {
        Contract con = new Contract(AccountId = [SELECT Id FROM Account LIMIT 1].Id, Status = 'Draft');
        Test.startTest(); 
        Contract result = ContractService.create(con);
        Test.stopTest();   
        System.assertNotEquals(null, result.Id, 'Le contrat doit être créé');
    }

    @isTest static void testGetById() {
        Contract con = [SELECT Id, Status FROM Contract LIMIT 1];
        Contract result = ContractService.getById(con.Id);
        System.assertEquals('Draft', result.Status, 'Le statut doit être "Draft"');
    }

    @isTest static void testUpdate() {
        Contract con = [SELECT Id FROM Contract LIMIT 1];
        con.Status = 'Activated';
        Test.startTest(); 
        ContractService.updateContract(con);
        Test.stopTest();   

        Contract updatedCon = [SELECT Status FROM Contract WHERE Id = :con.Id];
        System.assertEquals('Activated', updatedCon.Status, 'Le statut doit être mis à jour');
    }

    @isTest static void testDelete() {
        Contract con = [SELECT Id FROM Contract LIMIT 1];
        Test.startTest(); 
        ContractService.deleteContract(con.Id);
        Test.stopTest();   

        List<Contract> deletedCon = [SELECT Id FROM Contract WHERE Id = :con.Id];
        System.assertEquals(0, deletedCon.size(), 'Le contrat doit être supprimé');
    }
}