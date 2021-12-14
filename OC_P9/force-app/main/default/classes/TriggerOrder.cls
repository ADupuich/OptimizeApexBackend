public class TriggerOrder {


    public static void CalculNetAmountForOrder(List<Order> newOrder) {

        for (Order o : newOrder) {
            if (o.ShipmentCost__c != null) {
            o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            }
        }
    }

    public static void UpdateAccountCA(List<Order> newOrder) {
     //Begin with the accountId of order wich triggering. In order to clame only the accounts considered by the modificatio
        Set<Id> ordersId = new Set<Id>();
        for (order odr : newOrder) {
            ordersId.add(odr.AccountId);
        }

     List<Order> totalAmountToAddOnAccount = [SELECT TotalAmount, Account.Chiffre_d_affaire__c FROM Order WHERE AccountId IN :ordersId];
     Map<Id,Account> accountsWeWillUpdate = new Map<Id,Account>();
     for (Order o : totalAmountToAddOnAccount){
        if (accountsWeWillUpdate.containsKey(o.AccountId)) {
            Account tempAcc = accountsWeWillUpdate.get(o.accountId);
            tempAcc.Chiffre_d_affaire__c += o.TotalAmount;
            accountsWeWillUpdate.put(o.accountId,tempAcc);

        }
                Account acc = new account();
                acc.Id = o.accountId;
                acc.Chiffre_d_affaire__c = o.TotalAmount;
                accountsWeWillUpdate.put(o.AccountId,acc);
    }
        update accountsWeWillUpdate.values(); 
     }
}