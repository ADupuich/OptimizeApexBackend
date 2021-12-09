@isTest
public with sharing class testDataFactory {
    //This test method create as many account as we need
	public static List<Account> GenerateRandomAccounts(Integer noOfAccounts)
	{
		List<Account> accounts = new List<Account>();
		for( Integer i = 0; i < noOfAccounts; i++ ) {
			
            Account accts = new Account( Name = 'Test Account '+i);
			accounts.add(accts);
		}
        insert accounts;
		return accounts;
	}

    //This test method create Product that we need to test Orders
    public static Product2 GenerateProducts() {
        Product2 chemiseVerte = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert chemiseVerte;
        return chemiseVerte;
    }

    //This test method create PricebookEntry
    public static PricebookEntry GeneratePricebook(Product2 chemiseVerte) {
        PricebookEntry Pricebook = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = chemiseVerte.Id,
        UnitPrice = 1020,
        IsActive = true
        );
        insert Pricebook;
        return Pricebook;
    }

    //This method create as many order as we need
    public static List<Order> GenerateRandomOrders(Integer noOfOrders, List<Account> accounts, PricebookEntry Pricebook, Integer DesiredShipmentCost) {
        //create an orders List to use after
        List<Order> orders = new List<Order>();
        /*What we need to create an order in Fasha's Org
        We need accountId. This is to catch only accountsId to easely use them when we are going to create orders*/
        List<Id> listAccountsId = new List<Id>();
        for (Account a : accounts) {
            listAccountsId.add(a.Id);
        }
        //Now let's add the orders in the list with one of AccountId prepared before
        for (Integer i = 0; i < noOfOrders; i++) {
            //this is to select a random index in listAccountsId
            Integer t = Integer.valueof((Math.random() * (listAccountsId.size()-1)));
            //this is to get the ID that the random index refer
            Id referToAccount = listAccountsId.get(t);
            //now we can create the order and pass it an account ID with the required informations          
            Order odr = new Order (AccountId = referToAccount,
                                   EffectiveDate = Date.today(),
                                   Status = 'Draft',
                                   Pricebook2Id = Pricebook.Pricebook2Id,
                                   shipmentCost__c = DesiredShipmentCost);
            orders.add(odr);
            }
        //insert and return the orders
        insert orders;
        return orders;
    }

    //This test method create Order Item related to an existing order
    public static OrderItem GenerateOrderItems(List<Order> orders, PricebookEntry Pricebook, Integer desiredQuantity) {
        OrderItem oi;
        for (Order o : orders) {
           oi = new OrderItem(OrderId = o.Id, PricebookEntryId = Pricebook.Id, Quantity = desiredQuantity, UnitPrice = Pricebook.UnitPrice);
           insert oi;
        }
        return oi;
    }
    
    public static List<Order> GenerateOrders(Integer noOfOrders, Integer ShipmentCost) {
        List<Order> orders = new List<Order>();
        for(Integer i=0;i<noOfOrders;i++){
            Order ord = new Order();
            ord.shipmentCost__c = ShipmentCost;
        }
        insert orders;
        return orders;
    }

}
