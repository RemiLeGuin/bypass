trigger AccountBeforeUpdate on Account (before update) {

    if (Bypass.canTrigger('Bypass_AccountTrigger')) {
        AccountRatingUpdate accountRatingUpdate = new AccountRatingUpdate(Trigger.new);
        accountRatingUpdate.updateAccountRating();
    }

}