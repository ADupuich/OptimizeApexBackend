trigger orderTrigger on ORDER (before update, after update) {
    if (Trigger.isUpdate) {
        List<Order> newOrder = trigger.new;
        if(Trigger.isBefore){
        TriggerOrder.CalculNetAmountForOrder(newOrder);
        } /*else if (Trigger.isAfter) {
            List<Order> ordersWithSameAccountId = [SELECT TotalAmount, 
                                                    (SELECT Id, Chiffre_d_affaire__c FROM Account) 
                                                FROM Order 
                                                WHERE Id IN : trigger.new.Id];
            Account.Chiffre_d_affaire__c = 0;
            for (Order o : ordersWithSameAccountId) {
                account.Chiffre_d_affaire__c += o.TotalAmount;
            }
        update Account;*/
    }      
}