trigger orderTrigger on ORDER (before update, after update) {
    if (Trigger.isUpdate) {
        List<Order> newOrder = trigger.new;
        if(Trigger.isBefore){
            TriggerOrder.CalculNetAmountForOrder(newOrder);
        } else if (Trigger.isAfter) {
            Set<Id> accountsId = TriggerOrder.AccountToUpdate(newOrder);
            DataUpdate.UpdateAccountCA(accountsId);
            
        }
    }      
}