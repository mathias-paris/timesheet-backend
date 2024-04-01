import ballerina/http;

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
}
