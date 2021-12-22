@isTest
private class TestMyTeamOrdersController {

@TestSetup
static void makeData() {       
//Test Data Setup
List<Account> accounts = DataFactory.GenerateRandomAccounts(1);
Product2 chemiseVerte = DataFactory.GenerateProducts();
PricebookEntry Pricebook = DataFactory.GeneratePricebook(chemiseVerte); 

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
  insert u1;

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
  insert u2;
}
    @IsTest
    static void testGetSelectedTeamOrdersInformations(){
      List<User> userList = [SELECT Id, ProfileId, LastName, Email, UserName, Alias, TimeZoneSidKey, EmailEncodingKey, LanguageLocaleKey, LocaleSidKey FROM User WHERE Alias = 'alias'];
      Id ProfileIdWeKeep = [SELECT Id FROM Profile WHERE Name = 'Canards'].Id;
      List<Order> relatedOrders = [SELECT Id FROM Order WHERE CreatedById IN :userList];
      List<Account> accounts = [SELECT ID FROM Account];
      List<PricebookEntry> pricebooks = [SELECT Id, Pricebook2Id, UnitPrice FROM PricebookEntry];
      PricebookEntry pricebook = pricebooks.get(0);
      User u1 = userList.get(0);
      User u2 = userList.get(1);
      Test.startTest();
      System.runAs(u1){
        List<Order> newOrders1 = DataFactory.GenerateRandomOrders(1, accounts, pricebook, 0);
        OrderItem itemToOrder1 = DataFactory.GenerateOrderItems(newOrders1,pricebook,1);
        }
        //Bono if you are here ? :p 
        System.runAs(u2){
        List<Order> newOrders2 = DataFactory.GenerateRandomOrders(1, accounts, pricebook, 0);
        OrderItem itemToOrder2 = DataFactory.GenerateOrderItems(newOrders2,pricebook,1);
        }
        User AdmProfile = [SELECT Id, Name FROM User WHERE Profile.Name =: 'System Administrator' limit 1];
        System.runAs(AdmProfile){
          List<Order> newOrder3 = [SELECT Status FROM Order];
          List<Order> ordersToUpdate = new List<Order>();
          for (Order o : newOrder3) {
            o.status = 'Ordered';
            ordersToUpdate.add(o);
          }
          update ordersToUpdate;
        }
        //Control the method to get informations of teams order do the job correctly
        //Créeons une liste d'order sur laquelle nous appelons cette méthode
        List<Order> controlSelectionOfOrders = new List<Order>();
        String newId = String.valueOf(ProfileIdWeKeep);
        controlSelectionOfOrders = ActionsForMyTeamOrders.getSelectedTeamOrdersInformations(userList, newId, relatedOrders);
      Test.stopTest();
      
      System.assert(controlSelectionOfOrders.size() == 2, 'There is not enough Order if you want the ducks make there job');
    }

    @isTest
    static void testgetTotalForTeam() {
    //Access to the data we need
    List<Account> accounts = [SELECT ID FROM Account];
    List<PricebookEntry> pricebooks = [SELECT Id, Pricebook2Id, UnitPrice FROM PricebookEntry];
    PricebookEntry pricebook = pricebooks.get(0);
    List<User> userList = [SELECT Id, ProfileId, LastName, Email, UserName, Alias, TimeZoneSidKey, EmailEncodingKey, LanguageLocaleKey, LocaleSidKey FROM User WHERE Alias = 'alias'];
    User u1 = userList.get(0);
    User u2 = userList.get(1);
    Id ProfileIdWeKeep = [SELECT Id FROM Profile WHERE Name = 'Canards'].Id;
        Test.startTest();
        //Pour une équipe il faut au moins 2 personnes, c'est pourqioi nous allons créer des commandes provenant de 2 users différents et dont le profil est identique
        System.runAs(u1){
        List<Order> newOrders1 = DataFactory.GenerateRandomOrders(1, accounts, pricebook, 0);
        OrderItem itemToOrder1 = DataFactory.GenerateOrderItems(newOrders1,pricebook,1);
        }
        //Bono if you are here ? :p 
        System.runAs(u2){
        List<Order> newOrders2 = DataFactory.GenerateRandomOrders(1, accounts, pricebook, 0);
        OrderItem itemToOrder2 = DataFactory.GenerateOrderItems(newOrders2,pricebook,1);
        }
        //Now I need to makje this orders 'ordered' puisque c'est une condition de ma selection
        //To do this I nedd to be log as Admin
        User AdmProfile = [SELECT Id, Name FROM User WHERE Profile.Name =: 'System Administrator' limit 1];
        System.runAs(AdmProfile){
          List<Order> newOrder3 = [SELECT Status FROM Order];
          List<Order> ordersToUpdate = new List<Order>();
          for (Order o : newOrder3) {
            o.status = 'Ordered';
            ordersToUpdate.add(o);
          }
          update ordersToUpdate;
        }
        Test.stopTest();
        //Nous allons vérfier que le montant total des commandes de la team canard est bien de 2040 (2 Order created for the test for each one 1 chemiseVerte that cost 1020)
        //Je sélectionne les users qui m'intéressent pour vérifier le réulstat du test
        List<User> usersIdWithCanardProfil = [SELECT Id FROM User WHERE ProfileId = :ProfileIdWeKeep];
        List<Order> relatedOrders = [SELECT Id FROM Order WHERE CreatedById IN :usersIdWithCanardProfil];
        //le paramètre de la méthode à tester est un string du fait de l'interaction avec la VFpage donc je converti mon Id en string pour l'utiliser comme paramètre
        String newId = String.valueOf(ProfileIdWeKeep);
        //Enfin j'appelle la méthode qui est censé me retourner le momntant total de mes orders pour une équipe
        Decimal canardsOrdersValue = ActionsForMyTeamOrders.getTotalForTeam(usersIdWithCanardProfil,newId,relatedOrders);
        //J'attendais un résultat de 2040, je vérfie que c'est bien le cas
        System.assert(canardsOrdersValue == 2040, canardsOrdersValue+' Ducks make not the job!');
    }
}
