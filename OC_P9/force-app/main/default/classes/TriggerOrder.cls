public class TriggerOrder {


    public static void CalculNetAmountForOrder(List<Order> newOrder) {

        for (Order o : newOrder) {
            if (o.ShipmentCost__c != null) {
            o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            }
        }
    }
}