# issue-wanted-draft
This proof of concept queries the GitHub REST API and provides results via HTTP.

It uses the [GitHub](https://github.com/phadej/github) library to query a GitHub REST endpoint (issues for a repository) and inspect the returned data (how many of the issues are open/closed?). The results are served via Servant.

## Build
```
stack build
```

## Run
```
stack exec issues-wanted-draft-exe -- owner-name repo-name
```
or
```
stack exec issues-wanted-draft-exe
```
to get results for [issue-wanted](https://github.com/kowainik/issue-wanted).

## Query
The endpoints are (each open to GET requests):
localhost:8080/successfulqueries
localhost:8080/failedqueries
localhost:8080/totalissues
localhost:8080/openissues
