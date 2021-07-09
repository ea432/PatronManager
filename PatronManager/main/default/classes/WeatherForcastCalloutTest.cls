@isTest
public class WeatherForcastCalloutTest {
	
    @testSetup static void cityData(){
        City__c newYork = new City__c(Name = 'New York',
                                    Max_temp__c = 75,
                                    Min_temp__c = 44,
                                    Last_Sync__c = DateTime.now(),
                                    Predictability__c = 66,
                                    The_temp__c = 70,
                                    Weather_state_name__c = 'Clear',
                                    woeid__c = 2459115);
        insert newYork;
    }
    
    @isTest static void testGetWeatherForecastForAllCities(){
        List<City__c> newYorkCity = [Select Id, Name, Max_temp__c From City__c];
        List<City__c> retrievedCities;
        Test.startTest();
        WeatherForecastCallout weatherCallout = new WeatherForecastCallout();
        retrievedCities = weatherCallout.getWeatherForecastForAllCities();
        Test.stopTest();
 
        
        System.assertEquals(newYorkCity[0].Name, retrievedCities[0].Name);
    }
}