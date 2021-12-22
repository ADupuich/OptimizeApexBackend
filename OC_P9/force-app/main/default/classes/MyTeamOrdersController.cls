public class MyTeamOrdersController {

    public List<User> usersList;
    public List<Order> relatedOrders;
    public List<SelectOption> options;
    
    public List<Profile> teamsList {get;set;}
    public String selectedTeam{get;set;}

    public List<SelectOption> teamOption{
        get{
            return ActionsForMyTeamOrders.getTeamOption();
        }
        set {
            this.options = options;
        }
    }
    public decimal SumOrders {
        get{
            return ActionsForMyTeamOrders.getTotalForTeam(usersList, selectedTeam);
        }
        set;
    }
    public List<Order> TeamOrders {
        get{
        return ActionsForMyTeamOrders.getSelectedTeamOrdersInformations(usersList, selectedTeam, relatedOrders);
    }
    set;
    }   
}
