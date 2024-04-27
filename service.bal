import ballerina/http;
import ballerina/log;
//import ballerina/time;

type TimeEntry readonly & record {|
    string userId;
    string date;
    string project;
    string worklog;
    int duration;
|};

table<TimeEntry>  entries = table [
    {userId: "1", date: "2024-04-01", project: "Project A", worklog: "Worklog for Project A", duration: 1},
    {userId: "1", date: "2024-04-02", project: "Project A", worklog: "Worklog for Project A", duration: 3},
    {userId: "2", date: "2024-04-02", project: "Project A", worklog: "Worklog for Project A", duration: 2},
    {userId: "3", date: "2024-04-03", project: "Project B", worklog: "Worklog for Project B", duration: 4}
];

// Define a Ballerina service
service /timesheet on new http:Listener(8080) {

    // Resource to handle HTTP GET requests
    resource function get entries() returns json|http:NotFound {
        return entries.toJson();
    }

    // Resource to handle HTTP POST requests for creating new entries
    resource function post addEntry(http:Caller caller, http:Request req) returns error? {
        // Extract the JSON payload from the request
        json payload = check req.getJsonPayload();
        log:printInfo("Received JSON payload: "+ payload.toString());
        TimeEntry timeEntry = check payload.cloneWithType(TimeEntry);
        log:printInfo("record: "+timeEntry.toString());
        
        // Log the JSON payload


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
