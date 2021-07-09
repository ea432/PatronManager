<h1>Instructions:</h1>

1. Deploy the full package to your Developer org, or Scratch Org.
2. Run this line of code inside an anonymouse apex window, in order to schedule an hourly update for the weather forcast data.  
    "System.schedule('Get Recent Weather Forcast', '0 0 * * * ?', new SchedulableWeatherForcast());"
3. The main container component that houses the search and display functionality, lives on the default home page. Which can be accessed through the standard Service, Sales, etc.. apps.



<h2>TODO:</h2>

1. Decouple the WeatherForcastCallout class more, in order to be able to write more specific unit tests.<br/>
2. Beautify the layout of the container component, and each city it displays.<br/> 
3. Add additional null checks around the callout functionality code. So if the intergration fails, our application would fail gracefully.<br/> 
4. Create more user friendly toast messages. Currently it display system generated error messages that aren't user friendly.<br/>


<br/>
<br/>

<h4>User Story: Decouple/Refactor the code around the WeatherForcastCallout class.</h4>
Currently the code that is making the callout includes the parsing of the response body, in the same method. Your goal is to seperate that code, and perform the parsing in a seperate method. Next you would need to write test methods to test the new response parsing methods. 




