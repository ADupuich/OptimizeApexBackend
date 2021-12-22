@isTest
private class ActionsForMyTeamOrdersTests {
    @IsTest
    static void getTeamOptionTest(){
        //I have to test a selectOption List "options" out when a list of profile in
        
        Test.startTest();
        List<SelectOption> idAndNameFromProfile = new List<SelectOption>();
        idAndNameFromProfile = ActionsForMyTeamOrders.getTeamOption();
        Test.stopTest();

        //We are going to check if the list isn't empty
        System.assert(idAndNameFromProfile.size() > 0, 'You should have some Profil Data here');
    }
}
