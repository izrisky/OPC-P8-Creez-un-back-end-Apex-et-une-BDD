public with sharing class AccountService {
    public AccountService() {

    }
    public static Account create(Account acc) {
        Database.insert(acc);
        return acc;
    }

    public static Account updateAccount(Account acc) {
        Database.update(acc);
        return acc;
    }

    public static void deleteAccount(Id accountId) {
        Account acc = AccountSelector.getById(accountId);
        if (acc != null) {
            Database.delete(acc);
        }
    }
    public static Account getById(Id accountId) {
        return AccountSelector.getById(accountId);
    }
}