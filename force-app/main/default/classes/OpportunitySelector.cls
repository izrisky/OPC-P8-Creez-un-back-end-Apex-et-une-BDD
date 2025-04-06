public with sharing class OpportunitySelector {
    public static Opportunity getById(Id oppId) {
        try {
            Opportunity opportunity = [SELECT Id, Name, Amount FROM Opportunity WHERE Id = :oppId WITH SECURITY_ENFORCED LIMIT 1];
            if (opportunity == null) {
                System.debug('Access denied or ou no data available!');
            }
            return opportunity;
        } catch (SecurityException e) {
            System.debug('Security error : ' + e.getMessage());
            return null;
        }
    }

    public static List<Opportunity> getAll() {
        try {
            List<Opportunity> opportunities = [SELECT Id, Name, Amount, AccountId FROM Opportunity WITH SECURITY_ENFORCED];
            System.debug(opportunities.isEmpty() ? 'Access denied or ou no data available' : opportunities.size() + ' opportunities found');
            return opportunities;
        } catch (Exception e) {
            System.debug('Security error : ' + e.getMessage());
            return new List<Opportunity>();
        }
    }
}