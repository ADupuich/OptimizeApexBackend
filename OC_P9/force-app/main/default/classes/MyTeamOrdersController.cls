public class MyTeamOrdersController {

    public List<SelectOption> teamOption{set;}
    public List<Profile> teamsList {get;set;}
    public String selectedTeam{get;set;}

    public List<SelectOption> getTeamOption () {
        List<SelectOption> options = new List<SelectOption>();
        teamsList = [SELECT Id,Name FROM Profile];
        for(Profile pfl : teamsList) {
            options.add(new SelectOption(pfl.Id,pfl.Name));
        }
        return options;
    }

    public decimal SumOrders {
        get{
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order /*WHERE CreatedById IN :users*/];
			return (decimal)groupedResults.get('total');

        }
        set;
    }

}
