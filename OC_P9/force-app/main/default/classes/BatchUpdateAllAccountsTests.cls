@isTest
private class BatchUpdateAllAccountsTests {

    @TestSetup
    static void TestSetupForTrigger(){
        //Test Data Setup
        List<Account> accounts = DataFactory.GenerateRandomAccounts(101);
        Product2 chemiseVerte = DataFactory.GenerateProducts();
        PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte); 
        List<Order> newOrders = DataFactory.GenerateRandomOrders(145, accounts, Pricebook, 0);
        OrderItem itemToOrder = DataFactory.GenerateOrderItems(newOrders,Pricebook,1);
    }

    @IsTest
    static void TestBatchUpdateAllAccounts(){

    Test.startTest();
    //We are going to change the price of an OrderItem and if the Account Chiffre_d_affaire__c is correctly update when we are doing the Batch
    //So let's modifying the UnitPrice of Order Item
    List<OrderItem> orderItemList = [SELECT Id, UnitPrice FROM OrderItem];
    List<OrderItem> orderItemToUpdate = new List<OrderItem>();
    for (OrderItem oi : orderItemList) {
        oi.UnitPrice = 102;
        orderItemToUpdate.add(oi);
    }
    Update orderItemToUpdate;

    //Now the price is updated we are going to launch the Batch
    BatchUpdateAllAccounts batchTest = new BatchUpdateAllAccounts();
    Database.executeBatch(batchTest);
    //Batch done, what's the result ?
    Test.stopTest();

    //Check the account Chiffre_d_affaire__c was updating as we want. Actual value of Chiffre_d_affaire__c should be 102 * by the number of order related to the account
    //Firstly we need to choose how many orders must have the Account we are going to choose (voui, à attribuer aléatoirement les orders ... je ne sais pas trop quel account à combien de commande)
    //I choose to confirm that the account with only one order have Chiffre_d_affaire__c value equal to 102
    //So I select this accounts
    List<AggregateResult> accIdWithSingleOrder = [SELECT AccountId, COUNT(Id) totalOrders FROM Order GROUP BY AccountId HAVING COUNT(Id) = 1];
    //And now I work with one of them
    Id accountIdWithSingleOrder = (Id) accIdWithSingleOrder[0].get('AccountId');
    List<Account> newAccCAList = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id =: accountIdWithSingleOrder];
    Account AccountToCheckNewCA = newAccCAList.get(0);
    //Making assertion with the result we are expecting and the message returning if not
    System.assert(AccountToCheckNewCA.Chiffre_d_affaire__c == 102,'Dude, there is problem with the new Chiffre_d_affaire__c in Account');
        
    }
}