import ballerina/http;
import ballerina/log;

// Define a Ballerina service
service /timesheet on new http:Listener(8080) {

    // Resource to handle HTTP GET requests
    resource function get timeSheet() returns json {
        // Define your JSON data
        json data = [
            {
                "id": 1,
                "date": "2024-04-01",
                "project": "Project A",
                "worklog": "Worklog for Project A",
                "duration": "3 hours"
            },
            {
                "id": 2,
                "date": "2024-04-02",
                "project": "Project B",
                "worklog": "Worklog for Project B",
                "duration": "2 hours"
            },
            {
                "id": 3,
                "date": "2024-04-03",
                "project": "Project C",
                "worklog": "Worklog for Project C",
                "duration": "4 hours"
            }
        ];

        // Return the JSON data
        return data;
    }

    // Resource to handle HTTP POST requests for creating new entries
    resource function post addEntry(http:Caller caller, http:Request req) returns error? {
        // Extract the JSON payload from the request
        json payload = check req.getJsonPayload();
        
        // Log the JSON payload
        log:printInfo("Received JSON payload: "+ payload.toString());


        // Process the payload and add the new entry to the data array
        // Assuming the payload structure is similar to the JSON data in the GET resource
        // Logic to add the new entry to the data array goes here
        // Return an appropriate response
        http:Response response = new;
        response.setPayload("Entry added successfully");
        _ = check caller->respond(response);
        return ();
    }
}
