@isTest
private class TestBatchUpdateAllAccounts {

    @TestSetup
    static void TestSetupForTrigger(){
        //Test Data Setup
        List<Account> accounts = DataFactory.GenerateRandomAccounts(1);
        Product2 chemiseVerte = DataFactory.GenerateProducts();
        PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte); 
        List<Order> newOrders = DataFactory.GenerateRandomOrders(1, accounts, Pricebook, 0);
        OrderItem itemToOrder = DataFactory.GenerateOrderItems(newOrders,Pricebook,1);
    }

    @IsTest
    static void TestBatchUpdateAllAccounts(){

    Test.startTest();
    //Commençons par récupérer la valeur CA d'un Account
    //Récupérer les accounts et leur Ids
    List<Order> updateOrder= [SELECT Id FROM Order];
    update updateOrder;
    Set<Id> accIds = new Set<Id>();
    List<Account> accList = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Chiffre_d_affaire__c !=null];
    for (Account a : accList) {
        accIds.add(a.Id);
    }
    //accCA est à disposition avec une valeur C.A pas encore modifiée
    Account accCA = accList.get(0);

    //Allons modifier le prix du produit dans le PriceBook
    List<PricebookEntry> PricebookEntry = [SELECT UnitPrice FROM PricebookEntry];
    PricebookEntry AlonePricebookEntry = PricebookEntry.get(0);
    //Modifions le prix unitaire et divisons le par 10, il est désormais de 102
    AlonePricebookEntry.UnitPrice = 102;
    update AlonePricebookEntry;
    //C'est le moment de vérfier que les accounts vont bien se mettre à jour lors du batch
    BatchUpdateAllAccounts batchTest = new BatchUpdateAllAccounts();
    Database.executeBatch(batchTest);
    Test.stopTest();

    //Vérifions que le C.A de l'account en question a été mis à jour et que la nouvelle valeur de Chiffre_d_affaire__c est égale à l'ancienne Chiffre_d_affaire__c divisé par 10
    //Commençons par sélectionner nos Accounts nouvellement mis à jour
    List<Account> newAccList = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Chiffre_d_affaire__c !=null];
    Account newAccCA = newAccList.get(0);
    System.assert(newAccCA.Chiffre_d_affaire__c == 102, 'Dude, there is problem with the new Chiffre_d_affaire__c in Account');
        
    }
}