public class MyTeamOrdersController {

    public List<SelectOption> teamOption{set;}
    public List<Profile> teamsList {get;set;}
    public String selectedTeam{get;set;}
    public List<User> usersList;
    public List<Order> relatedOrders;


    public List<SelectOption> getTeamOption () {
        List<SelectOption> options = new List<SelectOption>();
        teamsList = [SELECT Id,Name FROM Profile];
        for(Profile pfl : teamsList) {
            options.add(new SelectOption(pfl.Id,pfl.Name));
        }
        return options;
    }

    public List<User> getSelectedTeamUsers () {
        //Firstly get the users we need
        usersList = new List<User>();
        usersList = [SELECT Name FROM User WHERE ProfileId =: selectedTeam];
        return usersList;
    }

    public static List<Order> getSelectedTeamOrdersInformations (List<User> usersList, String selectedTeam, List<Order> relatedOrders) {
        //Use this DATA to get the related orders
        usersList = new List<User>();
        usersList = [SELECT Name FROM User WHERE ProfileId =: selectedTeam];
        relatedOrders = new List<Order>();
        relatedOrders = [SELECT OrderNumber, Owner.Name, TotalAmount FROM order WHERE (Status = 'Ordered' AND CreatedById IN :usersList) ORDER BY createdById ASC]; 
        return relatedOrders;
    }

    public static Decimal getTotalForTeam (List<User> usersList, String selectedTeam){
        usersList = new List<User>();
        usersList = [SELECT Name FROM User WHERE ProfileId =: selectedTeam];
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE (Status = 'Ordered' AND CreatedById IN :usersList)];
        decimal totalForTeam = (decimal)groupedResults.get('total');
        if (totalForTeam == null) {
            totalForTeam = 0.00;
        }
        return totalForTeam;
    }

    public decimal SumOrders {
        get{
            return MyTeamOrdersController.getTotalForTeam(usersList, selectedTeam);
        }
        set;
    }
    
    public List<Order> TeamOrders {
        get{
        return MyTeamOrdersController.getSelectedTeamOrdersInformations(usersList, selectedTeam, relatedOrders);
    }
    set;
}
}
