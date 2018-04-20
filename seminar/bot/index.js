'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const restService = express();
restService.use(bodyParser.json());

require("string_score");

var peopleMap = require('./data.json')

restService.post('/webhook', function (req, res) {

    console.log('hook request');

    try {
        var speech = '';

        if (req.body) {
            var requestBody = req.body;

            if (requestBody.result) {
                var action = requestBody.result.action;

                if (action) {
                    console.log('query detected with action: ', action);
                    
                    var parameters = requestBody.result.parameters;
                    speech += handleAction(action,parameters);
                }
                else if (requestBody.result.fulfillment) {
                    speech += requestBody.result.fulfillment.speech;
                }
            }
        }

        console.log('result: ', speech);

        return res.json({
            speech: speech,
            displayText: speech,
            source: 'heroku_sample'
        });
    } catch (err) {
        console.error("Can't process request", err);

        return res.status(400).json({
            status: {
                code: 400,
                errorType: err.message
            }
        });
    }
});

//if running on heroku, heroku will assign the port
restService.listen((process.env.PORT || 5000), function () {
    console.log("Server listening");
});

//utility functions

//fuzzy name search
function findName(firstName,lastName){
    var names = Object.keys(peopleMap);
    
    var nameQuery = firstName;
    if(lastName){
        nameQuery += " " + lastName;
    }
     
    var topScore = 0.0;
    var nameToReturn = names[0];
    for(var i = 0; i < names.length; i++){
        var score = names[i].score(nameQuery);
        if(score > topScore){
            nameToReturn = names[i];
            topScore = score;
        }
    }
    
    if(topScore > 0.4){
        return nameToReturn;
    }
    else{
        return null;
    }
}

//action handling - these map to actions in our api.ai dashboard
function handleAction(action,parameters){
    if(action == "hometown"){
        var firstName = parameters["first-name"];
        var lastName = parameters["last-name"];
        
        var name = findName(firstName,lastName);
        
        if(name){
            return name + " is from " + peopleMap[name]["hometown"];
        }
        else{
            return "Somewhere on earth!"
        }
    }
    else if(action == "photo"){
        var firstName = parameters["first-name"];
        var lastName = parameters["last-name"];
       
        var name = findName(firstName,lastName);
        
        if(name){
            return "Check out this mug: " + peopleMap[name]["profile_pic"]["url"];
        }
        else{
            return "https://i.ytimg.com/vi/oHg5SJYRHA0/hqdefault.jpg";
        }
    }
    else if(action == "linkedin") {
        
        var firstName = parameters["first-name"];
        
        var name = findName(firstName, '');
        
        console.log(name);
        
        if (name) {
            return name + "'s LinkedIn is here: " + peopleMap[name]["linkedin"];
        } else {
            return "Couldn't find a LinkedIn";
        }
    }
    //your actions go here!:
    else{
        return "I don't know what you want :("
    }                      
}