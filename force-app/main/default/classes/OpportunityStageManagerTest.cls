/**
 * @description Test class for the OpportunityStageManager class.
 * This class ensures that the business logic for updating Opportunity stages
 * functions correctly and covers all relevant scenarios.
 */
@isTest
private class OpportunityStageManagerTest {

    // Use @testSetup to create test data once for all test methods in the class.
    @testSetup
    static void makeData() {
        // Create a test Account to associate with Opportunities
        Account testAccount = new Account(Name = 'Test Corp');
        insert testAccount;

        // Create a list of Opportunities to test various scenarios
        List<Opportunity> testOpps = new List<Opportunity>{
            // Scenario 1: Meets all criteria for update (High Value, Open Stage)
            new Opportunity(
                Name = 'High Value Opp',
                AccountId = testAccount.Id,
                Amount = 150000,
                StageName = 'Prospecting',
                CloseDate = Date.today().addMonths(1)
            ),
            // Scenario 2: Amount is too low to be updated
            new Opportunity(
                Name = 'Low Value Opp',
                AccountId = testAccount.Id,
                Amount = 50000,
                StageName = 'Prospecting',
                CloseDate = Date.today().addMonths(1)
            ),
            // Scenario 3: Already in the target 'Closed Won' stage
            new Opportunity(
                Name = 'Already Closed Opp',
                AccountId = testAccount.Id,
                Amount = 200000,
                StageName = 'Closed Won',
                CloseDate = Date.today().addMonths(1)
            )
        };
        insert testOpps;
    }

    @isTest
    static void testCloseHighValueOpp_Success() {
        // Arrange: Get the ID of the opportunity that should be updated.
        Opportunity highValueOpp = [SELECT Id FROM Opportunity WHERE Name = 'High Value Opp' LIMIT 1];
        List<Id> oppIds = new List<Id>{ highValueOpp.Id };

        Test.startTest();
        // Act: Call the method to be tested.
        OpportunityStageManager.closeHighValueOpportunities(oppIds);
        Test.stopTest();

        // Assert: Verify the stage was updated correctly.
        Opportunity updatedOpp = [SELECT StageName FROM Opportunity WHERE Id = :highValueOpp.Id];
        System.assertEquals('Closed Won', updatedOpp.StageName, 'The opportunity stage should be updated to Closed Won.');
    }

    @isTest
    static void testCloseOpp_AmountTooLow() {
        // Arrange: Get the ID of the opportunity with a low amount.
        Opportunity lowValueOpp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Low Value Opp' LIMIT 1];
        List<Id> oppIds = new List<Id>{ lowValueOpp.Id };

        Test.startTest();
        // Act: Call the method.
        OpportunityStageManager.closeHighValueOpportunities(oppIds);
        Test.stopTest();

        // Assert: Verify the stage has NOT changed.
        Opportunity resultOpp = [SELECT StageName FROM Opportunity WHERE Id = :lowValueOpp.Id];
        System.assertEquals(lowValueOpp.StageName, resultOpp.StageName, 'The stage should not have changed for a low value opportunity.');
    }

    @isTest
    static void testCloseOpp_AlreadyClosed() {
        // Arrange: Get the ID of the opportunity that is already closed.
        Opportunity alreadyClosedOpp = [SELECT Id FROM Opportunity WHERE Name = 'Already Closed Opp' LIMIT 1];
        List<Id> oppIds = new List<Id>{ alreadyClosedOpp.Id };

        Test.startTest();
        // Act: Call the method.
        OpportunityStageManager.closeHighValueOpportunities(oppIds);
        Test.stopTest();

        // Assert: Query to ensure no DML error occurred and the record is still present.
        Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE Id = :alreadyClosedOpp.Id AND StageName = 'Closed Won'];
        System.assertEquals(1, oppCount, 'The already closed opportunity should remain unchanged.');
    }

    @isTest
    static void testCloseOpp_EmptyListInput() {
        // Arrange: Create an empty list of IDs.
        List<Id> emptyOppIds = new List<Id>();

        Test.startTest();
        // Act: Call the method with an empty list.
        OpportunityStageManager.closeHighValueOpportunities(emptyOppIds);
        Test.stopTest();

        // Assert: No assertions are needed. The test passes if no exceptions are thrown,
        // which proves the empty list check is working correctly.
        System.assert(true, 'Method should handle empty list gracefully.');
    }
}