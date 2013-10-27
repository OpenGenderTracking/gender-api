A very simple API to get gender probability on a name and/or article. 


This is a sinatra app. To run it locally just do

    'ruby app.rb'

### API

It returns json.

#### Guess gender of the name.

    GET gender?name=anna


    {
        name: "anna",
        gender: "female"
    }
