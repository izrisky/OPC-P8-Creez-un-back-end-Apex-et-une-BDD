trigger CreateTripOnOpportunityClose on Opportunity (after update) {
    TripService.createTripForClosedWonOpportunities(Trigger.new, Trigger.oldMap);
}