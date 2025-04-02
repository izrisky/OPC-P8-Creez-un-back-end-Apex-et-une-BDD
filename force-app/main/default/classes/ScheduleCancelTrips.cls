global class ScheduleCancelTrips implements Schedulable {
    global void execute(SchedulableContext sc) {
        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch);
    }
}