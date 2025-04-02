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
private class AccountSelectorTest {
    @isTest static void testGetById() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;


        Test.startTest();
        Account result = AccountSelector.getById(acc.Id);
        Test.stopTest();
      
        System.assertNotEquals(null, result);
        System.assertEquals('Test Account', result.Name);
    }

    @isTest static void testGetAll() {
        Account acc1 = new Account(Name = 'Account 1');
        Account acc2 = new Account(Name = 'Account 2');
        insert new List<Account>{acc1, acc2};

        Test.startTest();
        List<Account> accounts = AccountSelector.getAll();
        Test.stopTest();

        System.assertNotEquals(0, accounts.size());
        Boolean foundAcc1 = false;
        Boolean foundAcc2 = false;

        for (Account acc : accounts) {
            if (acc.Name == 'Account 1') foundAcc1 = true;
            if (acc.Name == 'Account 2') foundAcc2 = true;
        }

        System.assert(foundAcc1, 'Account 1 not found');
        System.assert(foundAcc2, 'Account 2 not found');
    }
}