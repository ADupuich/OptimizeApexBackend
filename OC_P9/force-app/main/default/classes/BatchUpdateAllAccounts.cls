global class BatchUpdateAllAccounts implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        //modifier la requête pour filtrer
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> accountsId = (new Map<Id,SObject>(scope)).keySet();
        DataUpdate.UpdateAccountCA(accountsId);
    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }
