@isTest
private class tests {
  @isTest
    private static void testAccountsCreation() {
      List<Account> accounts = testDataFactory.GenerateRandomAccounts(1);
      Test.startTest();
        List<Account> checkAccts = [SELECT Id FROM Account];
      Test.stopTest();
      System.assert(checkAccts.size() == 1, 'Was expecting to find 10 Accounts');
    }
    @isTest
    private static void testOrdersCreation() {
        List<Account> accounts = testDataFactory.GenerateRandomAccounts(10);
        Product2 chemiseVerte = testDataFactory.GenerateProducts();
        PricebookEntry Pricebook = testDataFactory.GeneratePricebook(chemiseVerte);  
        List<Order> newOrders = testDataFactory.GenerateRandomOrders(2, accounts, Pricebook,10);
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
      List<Order> newOrders = testDataFactory.GenerateRandomOrders(2, accounts, Pricebook,10);
      OrderItem itemToOrder = testDataFactory.GenerateOrderItems(newOrders,Pricebook,10);
      //Perform Test
      Test.startTest();
      List<OrderItem> checkOi = [SELECT Quantity FROM OrderItem];
      Test.stopTest();
      System.assert(checkOi.size() >= 1 , 'Man, where is the item from order plz ?');
    }

//Data generation works correctly. Now we can create some test for the app.

//Test Trigger before order update to calcul the Net Amount
@isTest
private static void TestTriggerBeforeUpdateOrder() {
  //Test Data Setup
  List<Account> accounts = testDataFactory.GenerateRandomAccounts(1);
  Product2 chemiseVerte = testDataFactory.GenerateProducts();
  PricebookEntry Pricebook = testDataFactory.GeneratePricebook(chemiseVerte); 
  List<Order> newOrders = testDataFactory.GenerateRandomOrders(2, accounts, Pricebook, 10);
  OrderItem itemToOrder = testDataFactory.GenerateOrderItems(newOrders,Pricebook,1);
  //Perform Test
  Test.startTest();
    List<Order> OrdersToUpdate = [SELECT Status FROM Order];
    for (Order o : OrdersToUpdate) {
      o.Status = 'Ordered';
      update o;
    }
  Test.stopTest();
  List <Order> OrdersToTest = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Status = 'Ordered'];
  Order selectedOrder = OrdersToTest.get(0);

  Decimal OrderNetAmount = selectedOrder.NetAmount__c;
  Decimal OrderTotalAmount = selectedOrder.TotalAmount;
  Decimal CheckDifference = OrderTotalAmount - OrderNetAmount;

  System.assert(CheckDifference == 10, 'Il semble que les frais de port ne soient pas déduits correctement');
  System.assert(OrdersToTest.size() >= 1, 'La liste ordersToTest ne contient pas de valeurs');
}
//Test trigger after update to Update Account C.A
@isTest
private static void TestTriggerAfterUpdateOrder() {
  //note avec ce test I have a big mistake !! Lorsque je crée des OrderItem il ne me crée pas le nombre désiré d'orderitem par order
    //Test Data Setup
    List<Account> accounts = testDataFactory.GenerateRandomAccounts(1);
    Product2 chemiseVerte = testDataFactory.GenerateProducts();
    PricebookEntry Pricebook = testDataFactory.GeneratePricebook(chemiseVerte);
    //Nous allons générer 150 commandes pour s'assurer que la limite précédemment rencontrée n'existe plus 
    List<Order> newOrders = testDataFactory.GenerateRandomOrders(1, accounts, Pricebook, 10);
    //Chaque ligne de commande sera composée d'1 item à 1020
    OrderItem itemToOrder = testDataFactory.GenerateOrderItems(newOrders,Pricebook,3);
    //Perform Test
    Test.startTest();
    List<Account> ChiffreAffaireBeforeUpdate = [SELECT Chiffre_d_affaire__c FROM Account];
    Account accountCABeforeUpdate = ChiffreAffaireBeforeUpdate.get(0);
    Decimal CABeforeUpdate = 0.00;
    if (accountCABeforeUpdate.Chiffre_d_affaire__c != null) {
      CABeforeUpdate = accountCABeforeUpdate.Chiffre_d_affaire__c;}
    List<Order> OrdersToUpdate = [SELECT Status FROM Order];
    List<Order> odrFinalyUpdate = new List<Order>();
      for (Order o : OrdersToUpdate) {
        o.Status = 'Ordered';
        odrFinalyUpdate.add(o);
      }
    update odrFinalyUpdate;
    Test.stopTest();
    //Vérifier que le C.A de CABeforeUpdate != CAAfterUpdate
    List<Account> ChiffreAffaireAfterUpdate = [SELECT Chiffre_d_affaire__c FROM Account];
    //Le test suivant vérifie l'update du C.A sur un seul account
    Account AccountAfterUpdate = ChiffreAffaireAfterUpdate.get(0);
    Decimal CAAfterUpdate = AccountAfterUpdate.Chiffre_d_affaire__c;
    Decimal DifferenceBetweenBeforeAfter = CAAfterUpdate - CABeforeUpdate;
    //Il est attendu que la différence de chiffre d'affaire soit égale au nombre d'orders saisies multipliées par leur montant
     System.assert(DifferenceBetweenBeforeAfter == 3.00*1020.00, 'Il y a un petit soucis de mise à jour de C.A'); 
    }
}
