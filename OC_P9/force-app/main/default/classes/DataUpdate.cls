public with sharing class DataUpdate {

    public static void UpdateAccountCA(Set<Id> accountsId) {
        List<Order> relatedOrders = [SELECT TotalAmount, Account.Chiffre_d_affaire__c FROM Order WHERE (Status = 'Ordered' AND AccountId IN :accountsId)];
        Map<Id,Account> accountsWeWillUpdate = new Map<Id,Account>();
        for (Order o : relatedOrders){
           if (accountsWeWillUpdate.containsKey(o.AccountId)) {
               Account tempAcc = accountsWeWillUpdate.get(o.accountId);
               tempAcc.Chiffre_d_affaire__c += o.TotalAmount;
               accountsWeWillUpdate.put(o.accountId,tempAcc);
   
           } else {
            Account acc = new account();
            acc.Id = o.accountId;
            acc.Chiffre_d_affaire__c = o.TotalAmount;
            accountsWeWillUpdate.put(o.AccountId,acc);
            }
        }

           update accountsWeWillUpdate.values();
        }
    }
