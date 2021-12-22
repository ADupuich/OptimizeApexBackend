@isTest
private class DataFactoryTests {
  @isTest
    private static void testAccountsCreation() {
      List<Account> accounts = DataFactory.GenerateRandomAccounts(1);
      Test.startTest();
        List<Account> checkAccts = [SELECT Id FROM Account];
      Test.stopTest();
      System.assert(checkAccts.size() == 1, 'Was expecting to find 10 Accounts');
    }

    @isTest
    private static void testProductCreation() {
      Product2 chemiseVerte = DataFactory.GenerateProducts();
      Test.startTest();
        List<Product2> family = [SELECT Family FROM Product2 WHERE Name = 'Chemise Verte longue XYX'];
      Test.stopTest();
      System.assert(family.size() == 1, 'Y a pas de product là !!');
    }    
  @isTest
    private static void testPricebookCreation() {
      //Test Data Setup
      Product2 chemiseVerte = DataFactory.GenerateProducts();
      PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte);  
      //Perform Test  
      Test.startTest();
      List<PricebookEntry> checkPricebookEntry = [SELECT UnitPrice FROM PricebookEntry];
      Test.stopTest();
      System.assert(checkPricebookEntry.size() > 0, 'One PricebookEntry was expected');
    }
    
    @isTest
    private static void testOrdersCreation() {
        List<Account> accounts = DataFactory.GenerateRandomAccounts(10);
        Product2 chemiseVerte = DataFactory.GenerateProducts();
        PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte);  
        List<Order> newOrders = DataFactory.GenerateRandomOrders(2, accounts, Pricebook,10);
        Test.startTest();
          List<Order> checkOrders = [SELECT Id FROM Order];
        Test.stopTest();

        System.assert(checkOrders.size() ==2 , 'Was Expecting to have 2 orders');
    }

  @isTest
    private static void testOrderItemsCreation() {
      //Test Data Setup
      List<Account> accounts = DataFactory.GenerateRandomAccounts(10);
      Product2 chemiseVerte = DataFactory.GenerateProducts();
      PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte); 
      List<Order> newOrders = DataFactory.GenerateRandomOrders(2, accounts, Pricebook,10);
      OrderItem itemToOrder = DataFactory.GenerateOrderItems(newOrders,Pricebook,10);
      //Perform Test
      Test.startTest();
      List<OrderItem> checkOi = [SELECT Quantity FROM OrderItem];
      Test.stopTest();
      System.assert(checkOi.size() >= 1 , 'Man, where is the item from order plz ?');
    }
}

