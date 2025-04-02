trigger ValidateTripDates on Trip__c (before insert, before update) {
    for(Trip__c trip : Trigger.new) {
        if(trip.End_Date__c <= trip.Start_Date__c) {
            trip.addError('La date de fin doit être postérieure à la date de début.');
        }
    }
}