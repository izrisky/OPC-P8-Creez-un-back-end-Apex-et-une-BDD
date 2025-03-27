public with sharing class OpportunitySelector {
    public static Opportunity getById(Id oppId) {
        return [SELECT Id, Name, Amount FROM Opportunity WHERE Id = :oppId LIMIT 1];
    }

    public static List<Opportunity> getAll() {
        return [SELECT Id, Name, Amount FROM Opportunity];
    }
}