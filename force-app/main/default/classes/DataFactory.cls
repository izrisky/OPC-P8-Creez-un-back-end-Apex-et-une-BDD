public class DataFactory {

    public static void addData() {
        List<Account> accounts = new List<Account>();
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Trip__c> trips = new List<Trip__c>();

        // Créer 10 comptes réalistes
        List<String> companyNames = new List<String>{
            'Acme Corp', 'Globex Inc', 'Soylent Corp', 'Initech', 'Hooli',
            'Martin SINA', 'Wayne RONEY', 'Umbrella RIHANA', 'Wonka DUMBO', 'Tyrell SAM'
        };

        for (String companyName : companyNames) {
            Account acc = new Account(
                Name = 'OPC-P8-'+companyName,
                Phone = '555-123-4567'
            );
            accounts.add(acc);
        }
        insert accounts;

        // Créer des opportunités réalistes pour chaque compte
        for (Account acc : accounts) {
            Opportunity opp = new Opportunity(
                Name = 'Contract with ' + acc.Name,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(60),                
                Start_Date__c = Date.today().addDays(90),
                End_Date__c = Date.today().addDays(97),
                Amount = Math.random() * 100000,
                AccountId = acc.Id
            );
            opportunities.add(opp);
        }
        insert opportunities;

        // Créer des voyages réalistes
        List<String> destinations = new List<String>{'Marrakech','Paris', 'New York', 'Tokyo'};

        for (Opportunity opp : opportunities) {
            Integer randomIndex = (Integer)Math.floor(Math.random() * destinations.size());
            Trip__c trip = new Trip__c(
                Status__c = 'A venir',
                Destination__c = destinations[randomIndex],
                Start_Date__c = opp.Start_Date__c,
                End_Date__c = opp.End_Date__c,
                Number_of_Participants__c = Math.floor(Math.random() * 100) + 5,
                Total_Cost__c = 30000 + Math.random() * 20000,
                Account__c = opp.AccountId,
                Opportunity__c = opp.Id
            );
            trips.add(trip);
        }
        insert trips;
    }

    public static void addDataForTestBatch() {
        List<Opportunity> opportunities = OpportunitySelector.getAll();
        List<Trip__c> trips = new List<Trip__c>();

        // Créer des voyages réalistes
        List<String> destinations = new List<String>{'Marrakech','Paris', 'New York', 'Tokyo'};

        for (Opportunity opp : opportunities) {
            Integer randomIndex = (Integer)Math.floor(Math.random() * destinations.size());
            Integer numberParticipant=(Integer)Math.floor(Math.random() * 100) + 5;
            Trip__c trip = new Trip__c(
                Status__c = 'A venir',
                Destination__c = destinations[randomIndex],
                Start_Date__c = Date.today().addDays(7),
                End_Date__c = Date.today().addDays(17),
                Number_of_Participants__c =Math.Mod((Integer)Math.floor(Math.random() * 100) + 5,9),
                Total_Cost__c = 1000 + Math.random() * 200,
                Account__c = opp.AccountId,
                Opportunity__c = opp.Id
            );
            trips.add(trip);
        }
        insert trips;
    }
}