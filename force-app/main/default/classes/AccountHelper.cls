public class AccountHelper {
    
    // Method to return Accounts by Industry
    public static List<Account> getAccountsByIndustry(String industry) {
        if(String.isBlank(industry)) {
            return new List<Account>();
        }
        return [SELECT Id, Name, Industry FROM Account WHERE Industry = :industry LIMIT 50];
    }

    // Method to update Account Rating
    public static void updateAccountRating(Id accountId, String rating) {
        if(accountId == null || String.isBlank(rating)) {
            return;
        }
        Account acc = [SELECT Id, Rating FROM Account WHERE Id = :accountId LIMIT 1];
        acc.Rating = rating;
        update acc;
    }
}