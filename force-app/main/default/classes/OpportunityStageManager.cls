/**
 * @description A utility class to manage Opportunity stages.
 * This class provides methods to perform bulk updates on Opportunity records
 * based on specific business criteria.
 */
public with sharing class OpportunityStageManager {

    private static final Decimal AMOUNT_THRESHOLD = 100000;
    private static final String TARGET_STAGE = 'Closed Won';

    /**
     * @description Updates the stage of given Opportunities to 'Closed Won' if their
     * amount is above the defined threshold and they are not already won.
     * @param opportunityIds A list of IDs for the Opportunities to process.
     */
    public static void closeHighValueOpportunities(List<Id> opportunityIds) {
        // 1. Bulkification Guard: Exit early if the input list is empty or null.
        if (opportunityIds == null || opportunityIds.isEmpty()) {
            System.debug('Input list of Opportunity IDs is empty. No action taken.');
            return;
        }

        // 2. SOQL Query: Retrieve only the records that meet the criteria.
        // This is efficient as it prevents processing records that don't need updates.
        List<Opportunity> opportunitiesToUpdate = [
            SELECT Id, StageName, Amount
            FROM Opportunity
            WHERE Id IN :opportunityIds
            AND Amount > :AMOUNT_THRESHOLD
            AND StageName != :TARGET_STAGE
        ];

        // 3. Process Records: If the query returned results, update their stage.
        if (!opportunitiesToUpdate.isEmpty()) {
            for (Opportunity opp : opportunitiesToUpdate) {
                opp.StageName = TARGET_STAGE;
            }

            // 4. DML Operation: Perform a single update for all modified records.
            try {
                update opportunitiesToUpdate;
            } catch (DmlException e) {
                // In a real-world scenario, handle the exception gracefully.
                // For example, log the error or use Database.update for partial success.
                System.debug('An error occurred during Opportunity update: ' + e.getMessage());
                // Re-throw the exception to notify the calling process of the failure.
                throw e;
            }
        }
    }
}