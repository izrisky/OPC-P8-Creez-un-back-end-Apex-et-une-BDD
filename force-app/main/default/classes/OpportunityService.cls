public with sharing class OpportunityService {
    
    public static Opportunity create(Opportunity opp) {
        insert opp;
        return opp;
    }

    public static Opportunity getById(Id oppId) {
        return OpportunitySelector.getById(oppId);
    }

    public static Opportunity updateOpportunity(Opportunity opp) {
        update opp;
        return opp;
    }

    public static void deleteOpportunity(Id oppId) {
        Opportunity opp = OpportunitySelector.getById(oppId);
        if (opp != null) {
            delete opp;
        }
    }
}