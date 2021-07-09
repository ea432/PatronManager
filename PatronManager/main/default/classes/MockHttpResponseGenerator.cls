@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://www.metaweather.com/api/location/search/?query=New%20York', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"title":"New York", "location_type":"City", "woeid":"2459115", "latt_long":"40.71455,-74.007118"}');
        res.setStatusCode(200);
        return res;
    }
}