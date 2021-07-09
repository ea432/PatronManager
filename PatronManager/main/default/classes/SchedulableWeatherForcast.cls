/*
 * Description: this class is used to schedule periodic updates of the weather data, within the org.
 */ 
public class SchedulableWeatherForcast implements Schedulable{

    public void execute(SchedulableContext sc){
        performCallout();

    }

    @future(callout=true)
    public static void performCallout(){
        WeatherForecastCallout weatherCallout = new WeatherForecastCallout();
        List<City__c> retrievedCities = weatherCallout.getWeatherForecastForAllCities();
        Database.update(retrievedCities, false);
    }
    
}