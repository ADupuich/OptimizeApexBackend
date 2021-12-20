@isTest
private class TestMyTeamOrdersController {

@TestSetup
static void makeData() {       
//Test Data Setup
List<Account> accounts = DataFactory.GenerateRandomAccounts(1);
Product2 chemiseVerte = DataFactory.GenerateProducts();
PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte); 
}
    @isTest
    static void TestMyTeamOrdersController() {
    //Complete Data we need
        Id ProfileIdWeKeep = [SELECT Id FROM Profile WHERE Name = 'Canards'].Id;
        User u1 = new User(
            ProfileId = ProfileIdWeKeep,
            LastName = 'last.u1',
            Email = 'Cpt.Awesome@awesomesauce.com',
            UserName = 'u1Cpt.Awesome.' + DateTime.now().getTime() + '@awesomesauce.com',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
          );
          User u2 = new User(
            ProfileId = ProfileIdWeKeep,
            LastName = 'last.u2',
            Email = 'Cpt.Awesome@awesomesauce.com',
            UserName = 'u2Cpt.Awesome.' + DateTime.now().getTime() + '@awesomesauce.com',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
          );
    //Access to the data we need
    List<Account> accounts = [SELECT ID FROM Account];
    List<PricebookEntry> pricebooks = [SELECT Id, Pricebook2Id, UnitPrice FROM PricebookEntry];
    PricebookEntry pricebook = pricebooks.get(0);
        Test.startTest();
        //Ajouter le Created By
        //selectionner createedBy FROM order
        System.runAs(u1){
        List<Order> newOrders1 = DataFactory.GenerateRandomOrders(1, accounts, pricebook, 0);
        OrderItem itemToOrder1 = DataFactory.GenerateOrderItems(newOrders1,pricebook,1);
        }

        //Bono if you are here ? :p 
        System.runAs(u2){
        List<Order> newOrders2 = DataFactory.GenerateRandomOrders(1, accounts, pricebook, 0);
        OrderItem itemToOrder2 = DataFactory.GenerateOrderItems(newOrders2,pricebook,1);
        }
        
        //CreatedBy = canard
        Test.stopTest();

        //Nous allons vérfier que le montant total des commandes de la team canard est bien de 2040 (2 Order created for the test for each one 1 chemiseVerte that cost 1020)
        List<User> usersIdWithCanardProfil = [SELECT Id FROM User WHERE ProfileId = :ProfileIdWeKeep];

        //Sans doute remplacer après par le code suivant :
        //AggregateResult canardsOrdersM = MyTeamOrdersController.SumOrders; 
        AggregateResult canardsOrders = [SELECT SUM(TotalAmount) total FROM Order WHERE CreatedById IN :usersIdWithCanardProfil];
        Decimal canardsOrdersValue = (decimal)canardsOrders.get('total');

        System.assert(canardsOrdersValue == 2040, 'Ducks make not the job!');

    }
}
