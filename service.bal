import ballerina/http;
import ballerina/log;
import ballerina/time;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

//import ballerina/time;

configurable string dbhost = ?;
configurable string dbUsername = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbport = ?;

postgresql:Client dbClient = check new (host = dbhost, username = dbUsername,
    password = dbPassword, database = dbName, port = dbport
);

type TimeEntry record {|
    int id?;
    string user_id;
    time:Date date;
    string project;
    string worklog;
    int duration;
|};

// Define a Ballerina service
service /timesheet on new http:Listener(8080) {

    // Resource to handle HTTP GET requests
    resource function get entries() returns json|http:NotFound|error {
        log:printInfo("START");
        TimeEntry[] timeEntries = [];
        stream<TimeEntry, error?> resultStream = dbClient->query(
            `SELECT * FROM worklogs`
        );
        check from TimeEntry timeEntry in resultStream
            do {
                timeEntries.push(timeEntry);
            };
        check resultStream.close();
        return timeEntries.toJson();
    }

    // Resource to handle HTTP POST requests for creating new entries
    resource function post entry(http:Caller caller, http:Request req) returns error? {
        // Extract the JSON payload from the request
        json|http:ClientError timeEntryjson = req.getJsonPayload();
        if timeEntryjson is json {
            string user_id_string = "";
            string project_string = "";
            string date_string = "";
            string worklog_string = "";
            string duration_string = "";

            json|error user_id = timeEntryjson.user_id;
            if user_id is json {
                user_id_string = user_id.toString();
            }
            json|error date = timeEntryjson.date;
            if date is json {
                date_string = date.toString();
            }
            json|error project = timeEntryjson.project;
            if project is json {
                project_string = project.toString();
            }
            json|error worklog = timeEntryjson.worklog;
            if worklog is json {
                worklog_string = worklog.toString();
            }
            json|error duration = timeEntryjson.duration;
            if duration is json {
                duration_string = duration.toString();
            }
            string[] splittedValues = re `-`.split(date_string.trim());
            int day = check int:'fromString(splittedValues[2]);
            int month = check int:'fromString(splittedValues[1]);
            int year = check int:'fromString(splittedValues[0]);
            time:Date datedb = {year,month,day};

            int durationdb = check int:fromString(duration_string);

            sql:ExecutionResult result = check dbClient->execute(`
                INSERT INTO worklogs (user_id, date, project, worklog, duration)
                VALUES (${user_id_string}, ${datedb}, ${project_string},${worklog_string}, ${durationdb})
            `);
            int|string? lastInsertId = result.lastInsertId;
            if lastInsertId is int {
                check caller->respond(201);
            } 
        }
    }
}
