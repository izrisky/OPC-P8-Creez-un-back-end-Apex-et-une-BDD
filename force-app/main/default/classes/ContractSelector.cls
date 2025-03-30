public with sharing class ContractSelector {
    public static Contract getById(Id contractId) {
        return [SELECT Id, Status,ContractNumber FROM Contract WHERE Id = :contractId LIMIT 1];
    }

    public static List<Contract> getAll() {
        return [SELECT Id, ContractNumber FROM Contract];
    }
}