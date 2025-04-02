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
    public static void deleteAllOpportunities() {
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
        
        if (!opportunities.isEmpty()) {
            try {
                delete opportunities;
                System.debug('Toutes les opportunités ont été supprimées.');
            } catch (DmlException e) {
                System.debug('Erreur lors de la suppression des opportunités : ' + e.getMessage());
            }
        } else {
            System.debug('Aucune opportunité à supprimer.');
        }
    }
}