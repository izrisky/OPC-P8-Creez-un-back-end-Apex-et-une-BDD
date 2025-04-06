public with sharing class AccountSelector {
    public static Account getById(Id accountId) {
        
        try {
        Account account =[SELECT Id, Name FROM Account WHERE Id = :accountId  WITH SECURITY_ENFORCED LIMIT 1];
        if (account == null) {
            System.debug('Access denied or ou no data available!');
        }
        return account;
    } 
    catch (SecurityException e) {
        System.debug('Security error : ' + e.getMessage());
        return null;
    }
    }
    public static List<Account> getAll() {
        try {
            List<Account> accounts = [SELECT Id, Name FROM Account WITH SECURITY_ENFORCED];
            System.debug(accounts.isEmpty() ? 'Access denied or ou no data available' : accounts.size() + ' accounts found');
            return accounts;
        } catch (Exception e) {
            System.debug('Security error : ' + e.getMessage());
            return new List<Account>();
        }
    }
}