public with sharing class ContractSelector {

    public static Contract getById(Id contractId) {
        try {
            Contract contract = [SELECT Id, Status,ContractNumber FROM Contract WHERE Id = :contractId WITH SECURITY_ENFORCED LIMIT 1];
            if (contract == null) {
                System.debug('Access denied or ou no data available!');
            }
            return contract;
        } catch (SecurityException e) {
            System.debug('Security error : ' + e.getMessage());
            return null;
        }
    }

    public static List<Contract> getAll() {
        try {
            List<Contract> contracts = [SELECT Id, ContractNumber FROM Contract WITH SECURITY_ENFORCED];
            System.debug(contracts.isEmpty() ? 'Access denied or ou no data available' : contracts.size() + ' contracts found');
            return contracts;
        } catch (Exception e) {
            System.debug('Security error : ' + e.getMessage());
            return new List<Contract>();
        }
    }
}