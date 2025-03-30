public with sharing class AccountSelector {
    public AccountSelector() {

    }
    public static Account getById(Id accountId) {
        return [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];
    }
    public static List<Account> getAll() {
        return [SELECT Id, Name FROM Account];
    }
}