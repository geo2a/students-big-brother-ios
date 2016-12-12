# Student’s Big Brother iOS

Main goal of this project is to develop simple iOS client app for 
Student’s Big Brother.   

### About Student’s Big Brother

Student’s Big Brother is a distributed system to support study workflow in 
programming class. It’s created to help teacher to uniformly distribute his/her 
attention between all students. System consists of client daemons, 
watching students activity and sending source code to server (over HTTP), 
for storage, processing and displaying in teacher web-interface. 
Sources of server, client daemon and teacher's frontend are available on 
[GitHub](https://github.com/geo2a/students-big-brother).

### Functionality announce

App is going to provide following functions: 

* Display list of active students
* Display source code files for each active student with syntax highlighting
* Somehow (not yet decided) update contents: either on user request (user pushes refresh button) or automatically, 
  or something in-between (with use of notifications)

### Credit aims

| Requirement                 | Credit  | Confidence level|
|-----------------------------|---------|-----------------|
| Basic Functioning App       | 20      | 100%            |
| Use of standard libraries   | 10      | 90%             |
| Use of additional libraries | 10      | 100%            |
| Remote data download        | 10      | 100%            |
| Complex UI Logic            | 15      | 50%             |
