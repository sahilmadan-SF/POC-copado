@isTest
public class AccountHelperTest {
    
    @testSetup
    static void setupData() {
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name='Tech Corp', Industry='Technology', Rating='Cold'));
        accList.add(new Account(Name='Finance Inc', Industry='Finance', Rating='Warm'));
        insert accList;
    }
    
    @isTest
    static void testGetAccountsByIndustry() {
        // Valid industry
        List<Account> techAccounts = AccountHelper.getAccountsByIndustry('Technology');
        System.assertEquals(1, techAccounts.size());
        
        // Blank industry
        List<Account> blankAccounts = AccountHelper.getAccountsByIndustry('');
        System.assertEquals(0, blankAccounts.size());
    }
    
    @isTest
    static void testUpdateAccountRating() {
        Account acc = [SELECT Id, Rating FROM Account WHERE Industry = 'Finance' LIMIT 1];
        
        // Valid update
        AccountHelper.updateAccountRating(acc.Id, 'Hot');
        Account updatedAcc = [SELECT Id, Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Hot', updatedAcc.Rating);
        
        // Null accountId
        AccountHelper.updateAccountRating(null, 'Warm');
        
        // Blank rating
        AccountHelper.updateAccountRating(acc.Id, '');
    }
}