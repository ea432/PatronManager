@isTest
public class PatronManagerContainerControllerTest {

    @isTest static void testSaveSearchedCity(){
		WeatherForecastCallout.MetaWeatherObject metaObject = new WeatherForecastCallout.MetaWeatherObject();
        metaObject.woeid = 2459115; 
        metaObject.title = 'New York';
        metaObject.weather_state_name = 'Clear';
        metaObject.min_temp ='13';
        metaObject.max_temp ='25';
        metaObject.the_temp ='22';
        metaObject.predictability ='65';
        
        Test.startTest();
        PatronManagerContainerController.saveSearchedCity(metaObject);
        Test.stopTest();
        
        List<City__c> queriedCity = PatronManagerContainerController.getCities();
        
        System.assertEquals(metaObject.title, queriedCity[0].Name);
        System.assertEquals(convertToFarenheit(metaObject.the_temp), queriedCity[0].The_temp__c);
        System.assertEquals(convertToFarenheit(metaObject.min_temp), queriedCity[0].Min_temp__c);
        System.assertEquals(metaObject.predictability, String.valueOf(queriedCity[0].Predictability__c));
        System.assertEquals(convertToFarenheit(metaObject.max_temp), queriedCity[0].Max_temp__c);
        System.assertEquals(metaObject.weather_state_name, queriedCity[0].Weather_state_name__c);
        System.assertEquals(metaObject.woeid, queriedCity[0].Woeid__c);
        
    }
    
    private static Decimal convertToFarenheit(String celciusNum){
        return Decimal.valueOf(celciusNum)*1.8+32;
    }
}