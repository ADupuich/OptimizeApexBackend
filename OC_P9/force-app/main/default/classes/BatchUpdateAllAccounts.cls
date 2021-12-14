public with sharing class BatchUpdateAllAccounts {
    global BatchUpdateAllAccounts() {
        global Database.QueryLocator start(Database.BatchableContext info){ 
            //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
            //modifier la requête pour filtrer
            return Database.getQueryLocator('SELECT Id FROM Account');
        }
         
        global void execute(Database.BatchableContext info, List<Account> scope){
            Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
            AP01Account.updateChiffreAffaire(setAccountIds);
    
            update scope;
        }    
         
        global void finish(Database.BatchableContext info){     
            
        } 
    }
}
