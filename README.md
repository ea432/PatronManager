Instructions:

1. Deploy the full package to your Developer org, or Scratch Org.
2. Run this line of code inside an anonymouse apex window, in order to schedule an hourly update for the weather forcast data System.schedule('Get Recent Weather Forcast', '0 0 * * * ?', new SchedulableWeatherForcast());
3. The main container component that houses the search and display functionality, lives on the default home page. Which can be accessed through the standard Service, Sales, etc.. apps.
