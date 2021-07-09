/*
 * Description: this class is the controller in the PatronManagerContainer aura component.
 */ 
public class PatronManagerContainerController {
    
    /*
     * Description: this method is used in the PatronManagerContaner aura cmp. It is used in the init method
     * to retrive all existing City__c records.
     */ 
    @AuraEnabled
    public static List<City__c> getCities(){
        return [Select Id, Name, The_temp__c, Min_temp__c,woeid__c, Max_temp__c, Weather_state_name__c, Predictability__c, Last_Sync__c
               From City__c Order By Name ASC];
        
    }

    /*
    * Description: this method is used for passing the searched key term, 
    * to the outbound weather callout class, from the PatronManagerContainer aura cmp.
    */
    @AuraEnabled
    public static void searchCity(String keyTerm){
        String formattedKeyTerm = keyTerm.trim();
        WeatherForecastCallout weatherForcastCallout = new WeatherForecastCallout();
        WeatherForecastCallout.MetaWeatherObject calloutResponse = weatherForcastCallout.getWeatherForecastForNewCity(formattedKeyTerm);
        saveSearchedCity(calloutResponse);
    }

    /*
    * Description: this method is used for saving a new searched city to the database, at the same time it converts 
    * celcius degrees results to farenheit degrees
    */
    @TestVisible
    private static void saveSearchedCity(WeatherForecastCallout.MetaWeatherObject newCity){
        City__c cityToInsert = new City__c(Name = newCity.title,
                                    Max_temp__c = Decimal.valueOf(newCity.max_temp)*1.8+32,
                                    Min_temp__c = Decimal.valueOf(newCity.min_temp)*1.8+32,
                                    Last_Sync__c = DateTime.now(),
                                    Predictability__c = Decimal.valueOf(newCity.predictability),
                                    The_temp__c = Decimal.valueOf(newCity.the_temp)*1.8+32,
                                    Weather_state_name__c = newCity.weather_state_name,
                                    woeid__c = newCity.woeid);
        try{
            insert cityToInsert;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }

}