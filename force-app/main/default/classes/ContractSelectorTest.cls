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
private class ContractSelectorTest {

    @isTest static void testGetById() {
        // Créer un enregistrement test pour Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer un enregistrement test pour Contract
        Contract con = new Contract(AccountId = acc.Id, Status = 'Draft'); // Utilisez un champ inscriptible
        insert con;

        // Appeler la méthode de requête
        Contract result = ContractSelector.getById(con.Id);

        // Vérifier le résultat
        System.assertNotEquals(null, result, 'Le contrat doit exister');
        System.assertEquals('Draft', result.Status, 'Le statut doit être "Draft"');
    }

    @isTest static void testGetAll() {
        // Créer un enregistrement test pour Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Créer plusieurs contrats de test
        Contract con1 = new Contract(AccountId = acc.Id, Status = 'Draft');
        Contract con2 = new Contract(AccountId = acc.Id, Status = 'Draft');
        insert new List<Contract>{con1, con2};

        // Appeler la méthode de requête
        List<Contract> contracts = ContractSelector.getAll();

        // Vérifier le résultat
        System.assertNotEquals(0, contracts.size(), 'La liste des contrats ne doit pas être vide');

        Boolean foundCon1 = false;
        Boolean foundCon2 = false;

        for (Contract con : contracts) {
            if (con.Id == con1.Id) foundCon1 = true;
            if (con.Id == con2.Id) foundCon2 = true;
        }

        System.assert(foundCon1, 'Le contrat 1 devrait être dans la liste');
        System.assert(foundCon2, 'Le contrat 2 devrait être dans la liste');
    }
}