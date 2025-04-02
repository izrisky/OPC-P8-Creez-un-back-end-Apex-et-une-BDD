global class ScheduleUpdateTripStatus implements Schedulable {
    global void execute(SchedulableContext sc) {
        UpdateTripStatusBatch batch = new UpdateTripStatusBatch();
        Database.executeBatch(batch);
    }
}