public class ActionsForMyTeamOrders {
    
    public static List<Order> getSelectedTeamOrdersInformations (List<User> usersList, String selectedTeam, List<Order> relatedOrders) {
        //Use this DATA to get the related orders
        usersList = new List<User>();
        usersList = [SELECT Name FROM User WHERE ProfileId =: selectedTeam];
        relatedOrders = new List<Order>();
        relatedOrders = [SELECT OrderNumber, Owner.Name, TotalAmount FROM order WHERE (Status = 'Ordered' AND CreatedById IN :usersList) ORDER BY createdById ASC]; 
        return relatedOrders;
    }

    public static Decimal getTotalForTeam (List<User> usersList, String selectedTeam, List<Order> relatedOrders){
        List<Order> listForTotal = ActionsForMyTeamOrders.getSelectedTeamOrdersInformations(usersList, selectedTeam, relatedOrders);
        decimal totalForTeam = 0.00;
            for (Order o : listForTotal) {
                totalForTeam += o.TotalAmount;
            } 
        return totalForTeam;
    }

    public static List<SelectOption> getTeamOption () {
        List<SelectOption> options = new List<SelectOption>();
        List<Profile> teamsList = [SELECT Id,Name FROM Profile];
        for(Profile pfl : teamsList) {
            options.add(new SelectOption(pfl.Id,pfl.Name));
        }
        return options;
    }
}
