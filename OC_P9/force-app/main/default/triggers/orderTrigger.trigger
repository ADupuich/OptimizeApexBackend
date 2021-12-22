trigger OrderTrigger on ORDER (before update, after update) {
    if (Trigger.isUpdate) {
        List<Order> newOrder = trigger.new;
        if(Trigger.isBefore){
            OrderTriggerHandler.CalculNetAmountForOrder(newOrder);
        } else if (Trigger.isAfter) {
            Set<Id> accountsId = OrderTriggerHandler.AccountToUpdate(newOrder);
            DataUpdate.UpdateAccountCA(accountsId);
            
        }
    }      
}