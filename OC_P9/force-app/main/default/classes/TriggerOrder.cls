public class TriggerOrder {


    public static void CalculNetAmountForOrder(List<Order> newOrder) {
            for (Order o : newOrder) {
                o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            }
        }
    }