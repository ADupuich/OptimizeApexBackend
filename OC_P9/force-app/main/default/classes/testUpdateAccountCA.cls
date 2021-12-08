@isTest
private class testUpdateAccountCA {
  @isTest
    private static void testAccountsCreation() {
      List<Account> accounts = testDataFactory.GenerateRandomAccounts(10);
      Test.startTest();
        List<Account> checkAccts = [SELECT Id FROM Account];
      Test.stopTest();
      System.assert(checkAccts.size() == 10, 'Was expecting to find 10 Accounts');
    }
    @isTest
    private static void testOrdersCreation() {
        List<Account> accounts = testDataFactory.GenerateRandomAccounts(10);
        Product2 chemiseVerte = testDataFactory.GenerateProducts();
        PricebookEntry Pricebook = testDataFactory.GeneratePricebook(chemiseVerte);  
        List<Order> newOrders = testDataFactory.GenerateRandomOrders(2, accounts, Pricebook);
        Test.startTest();
          List<Order> checkOrders = [SELECT Id FROM Order];
        Test.stopTest();

        System.assert(checkOrders.size() ==2 , 'Was Expecting to have 2 orders');
    }
    @isTest
    private static void testProductCreation() {
      Product2 chemiseVerte = testDataFactory.GenerateProducts();
      Test.startTest();
        List<Product2> family = [SELECT Family FROM Product2 WHERE Name = 'Chemise Verte longue XYX'];
      Test.stopTest();
      System.assert(family.size() == 1, 'Y a pas de product là !!');
    }    
  @isTest
    private static void TestPricebookCreation() {
      //Test Data Setup
      Product2 chemiseVerte = testDataFactory.GenerateProducts();
      PricebookEntry Pricebook = testDataFactory.GeneratePricebook(chemiseVerte);  
      //Perform Test  
      Test.startTest();
      List<PricebookEntry> checkPricebookEntry = [SELECT UnitPrice FROM PricebookEntry];
      Test.stopTest();
      System.assert(checkPricebookEntry.size() > 0, 'One PricebookEntry was expected');
    }
  @isTest
    private static void TestOrderItemsCreation() {
      //Test Data Setup
      List<Account> accounts = testDataFactory.GenerateRandomAccounts(10);
      Product2 chemiseVerte = testDataFactory.GenerateProducts();
      PricebookEntry Pricebook = testDataFactory.GeneratePricebook(chemiseVerte); 
      List<Order> newOrders = testDataFactory.GenerateRandomOrders(2, accounts, Pricebook);
      OrderItem itemToOrder = testDataFactory.GenerateOrderItems(newOrders,Pricebook,10);
      //Perform Test
      Test.startTest();
      List<OrderItem> checkOi = [SELECT Quantity FROM OrderItem];
      Test.stopTest();
      System.assert(checkOi.size() >= 1 , 'Man, where is the item from order plz ?');
    }
}