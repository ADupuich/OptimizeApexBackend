@isTest
private class OderTriggerTests {

@TestSetup
static void TestSetupForTrigger(){
    //Test Data Setup
    List<Account> accounts = DataFactory.GenerateRandomAccounts(1);
    Product2 chemiseVerte = DataFactory.GenerateProducts();
    PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte); 
    List<Order> newOrders = DataFactory.GenerateRandomOrders(180, accounts, Pricebook, 10);
    OrderItem itemToOrder = DataFactory.GenerateOrderItems(newOrders,Pricebook,1);

}

@isTest
private static void TestTriggerBeforeUpdateOrder() {
  //Perform Test
  Test.startTest();
  List<Order> orders = [SELECT Status FROM Order];
  List<Order> ordersToUpdate = new List<Order>();
    for (Order o : orders) {
      o.Status = 'Ordered';
      ordersToUpdate.add(o);
    }
    update ordersToUpdate;

  Test.stopTest();
  List <Order> OrdersToTest = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Status = 'Ordered'];
  Order selectedOrder = OrdersToTest.get(0);

  Decimal OrderNetAmount = selectedOrder.NetAmount__c;
  Decimal OrderTotalAmount = selectedOrder.TotalAmount;
  Decimal CheckDifference = OrderTotalAmount - OrderNetAmount;

  System.assert(CheckDifference == 10, 'Il semble que les frais de port ne soient pas déduits correctement');
  System.assert(OrdersToTest.size() >= 1, 'La liste ordersToTest ne contient pas de valeurs');
}
//Test trigger after update to Update Account C.A, see if C.A is different after update
@isTest
private static void TestTriggerAfterUpdateOrder() {
    //Perform Test
    Test.startTest();
    List<Order> ordersChangeStatus = [SELECT Status FROM Order];
    List<Order> ordersToUpdate = new List<Order>();
      for (Order o : ordersChangeStatus) {
        o.Status = 'Ordered';
        ordersToUpdate.add(o);
      }
      update ordersToUpdate;
    //prendre account et chiffre d'affaire avant de lancer un update sur une order
    List<Account> accList = [SELECT Chiffre_d_affaire__c FROM Account];
    Account selectedAcc = accList.get(0);
    Double selectedAccCA = SelectedAcc.Chiffre_d_affaire__c;
    //maintenant ajouter une order à avec cet account.Id
    //s'assurer que la mise à jour de C.A sur account se fait bien malgrés le fait qu'il y ai plus de 100 commandes
    List<Order> ordToAddItem = [SELECT TotalAmount, Id, Pricebook2Id FROM Order WHERE AccountId =: SelectedAcc.Id];
    //Je vais avoir besoin d'informations contenu dans une commande précise pour être sûr d'ajouter correctement une order
    //C'est à ça que servira cette variable
    Order getPricebook2Id = ordToAddItem.get(0);
    //Ajoutons cette Order
    Order addOrder = new Order(AccountId = SelectedAcc.Id,
                              EffectiveDate = Date.today(),
                              Status = 'Draft',
                              Pricebook2Id = getPricebook2Id.Pricebook2Id,
                              shipmentCost__c = 10);
    insert addOrder;
    //Pour que l'order soit contabilisée correctement, je vais avoir besoin d'item ce que nous allons créer maintenant
    //d'abord requêtons les infos nécessaires à cette création et à son afffiliation correcte dans l'organisation
    List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry];
    //la variable selectPricebook me permettra d'accéder facilement aux données nécessaires
    PricebookEntry selectPricebook = pricebookEntries.get(0);
    //Ajoutons l'OrderItem
    OrderItem itemToPush = new OrderItem();
    //Le dernier paramètre de itemToPush est le montant que nous souhaitons ajouter à notre CA Total sur Account, c'est celui qui est attendu dans le test
    //S'il est changé ici, pensez à le modifier dans l'assertion
    itemToPush = DataFactory.AddOrderItems(addOrder.Id, selectPricebook.Id, 10);
    insert itemToPush;

    addOrder.Status = 'Ordered';
    //lance le trigger afin de voir si le C.A est différent
    update addOrder;

    Test.stopTest();
    //Vérifier que le C.A de CABeforeUpdate != CAAfterUpdate
    List<Account> accListUpdated = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id =: SelectedAcc.Id];
    //Le test suivant vérifie l'update du C.A sur un seul account
    Account accActual = accListUpdated.get(0);
    Decimal CAActualAcc = accActual.Chiffre_d_affaire__c;
    Decimal DifferenceBetweenBeforeAfter = CAActualAcc - SelectedAccCA;
    //Il est attendu que la différence de chiffre d'affaire soit égale au montant de l'oder item renseigné en paramètre dans itemToPush, ici = 10.00
    System.assert(DifferenceBetweenBeforeAfter == 10.00, ' Il y a un petit soucis de mise à jour de C.A'); 
    }
}