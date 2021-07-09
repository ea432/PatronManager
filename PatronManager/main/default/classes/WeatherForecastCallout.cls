/*
 * Description: This class is used for making callouts to the MetaWeather API, 
 * and also process the outbound/inbound requests.
 */ 
public class WeatherForecastCallout {
    
    //Use these two variables to store title and woedid to combine with the second MetaWeather callout,
    //when building the MetaWeatherObject
    public Integer woeid;
    public String title;

    /*
     * Description: this method is used for the periodic callouts made, to update all the city__c records in the org
     */
    public List<City__c> getWeatherForecastForAllCities(){
        List<City__c> savedCities = [Select Id,woeid__c,Name From City__c];
        List<City__c> citiesToUpdate = new List<City__c>();
        for(City__c aCity: savedCities){
            MetaWeatherObject calloutResponse = getForcatsWithWhereInTheWorldId((Integer)aCity.woeid__c);
            City__c cityToUpdate = parseWeatherForecastResponse(calloutResponse, aCity);
            citiesToUpdate.add(cityToUpdate);
        }
        System.debug('citiesToUpdate: '+citiesToUpdate);
        return citiesToUpdate;
    }
    
    /*
     * Description: this method is used for a single callout, when a new city__c record is added to the dashboard
     */ 
    public MetaWeatherObject getWeatherForecastForNewCity(String searchName){
        searchName = searchName.replace(' ', '%20');
        String endpointString = 'https://www.metaweather.com/api/location/search/?query='+searchName;
        HttpRequest req = new HttpRequest();
     	req.setEndpoint(endpointString);
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String resString = res.getBody();
        
        try{
            List<MetaWeatherObject> parsedResponse = (List<MetaWeatherObject>)JSON.deserialize(resString, List<MetaWeatherObject>.class);
            this.woeid = parsedResponse[0].woeid;
            this.title = parsedResponse[0].title;

        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
        //Get full forcats data
        return getForcatsWithWhereInTheWorldId(this.woeid);
    }

    /*
    * Description: this method is used to retrive forcast data for a city by using the WhereInTheWorldId
    */
    public MetaWeatherObject getForcatsWithWhereInTheWorldId(Integer WhereInTheWorldId){
        System.debug('WhereInTheWorldId: '+WhereInTheWorldId);
        String endpointString = 'https://www.metaweather.com/api/location/'+WhereInTheWorldId+'/';
        HttpRequest req = new HttpRequest();
     	req.setEndpoint(endpointString);
        req.setMethod('GET');
        System.debug(endpointString);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String resString = res.getBody();
        MetaWeatherObject parsedResponse;
        
        try{
            Map<String, Object> returnedMap = (Map<String, Object>)JSON.deserializeUntyped(resString);
            List<Object> consolidatedWeather = (List<Object>)returnedMap.get('consolidated_weather');
            parsedResponse = (MetaWeatherObject)JSON.deserialize(JSON.serialize(consolidatedWeather[0]), MetaWeatherObject.class);
            parsedResponse.title = this.title;
            parsedResponse.woeid = this.woeid;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        return parsedResponse;

    }
    
    /*
     * Description: this method is used for parsing the response from MetaWeather API.
     */ 
    public City__c parseWeatherForecastResponse(MetaWeatherObject calloutObj, City__c databaseCityRec){
        City__c cityToUpdate = new City__c(Name = databaseCityRec.Name,
                                    Max_temp__c = Decimal.valueOf(calloutObj.max_temp)*1.8+32,
                                    Min_temp__c = Decimal.valueOf(calloutObj.min_temp)*1.8+32,
                                    Last_Sync__c = DateTime.now(),
                                    Predictability__c = Decimal.valueOf(calloutObj.predictability),
                                    The_temp__c = Decimal.valueOf(calloutObj.the_temp)*1.8+32,
                                    Weather_state_name__c = calloutObj.weather_state_name,
                                    woeid__c = databaseCityRec.woeid__c,
                                    Id = databaseCityRec.Id);
        return cityToUpdate;
    }


    public class MetaWeatherObject{
        public Integer woeid {get; set;}
        public String title {get; set;}
        public String weather_state_name {get; set;}
        public String min_temp {get; set;}
        public String max_temp {get; set;}
        public String the_temp {get; set;}    
        public String predictability {get; set;}
    }

}