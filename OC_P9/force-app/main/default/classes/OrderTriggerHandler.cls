public class OrderTriggerHandler {


    public static void CalculNetAmountForOrder(List<Order> newOrder) {

        for (Order o : newOrder) {
            if (o.ShipmentCost__c != null) {
            o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            }
        }
    }

    public static Set<Id> AccountToUpdate(List<Order> newOrder) {
     //Begin with the accountId of order wich triggering. In order to clame only the accounts considered by the modificatio
        Set<Id> accountsId = new Set<Id>();
        for (order odr : newOrder) {
            accountsId.add(odr.AccountId);
        }
        return accountsId;
     }
}