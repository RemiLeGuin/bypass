public with sharing class AccountRatingUpdate {

    public Account[] accounts;

    public AccountRatingUpdate(Account[] accounts) {
        this.accounts = accounts;
    }

    public void updateAccountRating() {
        for (Account acc : accounts) {
            if (acc.AnnualRevenue != null) {
                if (acc.AnnualRevenue > 1000000) {
                    acc.Rating = 'Hot';
                } else if (acc.AnnualRevenue > 500000) {
                    acc.Rating = 'Warm';
                } else if (acc.AnnualRevenue > 0) {
                    acc.Rating = 'Cold';
                }
            }
        }
    }

}