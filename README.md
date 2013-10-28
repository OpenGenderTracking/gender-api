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

#### Get gender of a text.

    POST content?text=Something that he wanted to say.

    {
        "result": "Male",
        "counts": {
            "male": 7,
            "female": 0,
            "neutral": 0
        }
    }

#### Get how many femail and male are in a text

    POST people?text=Maria and Anne were talking.


    {
        "Went": {
            "first": "George",
            "surname": "Went",
            "count": 1,
            "gender": "male"
        },
        "Hensley": {
            "first": "Went",
            "surname": "Hensley",
            "count": 2,
            "gender": "unknown"
        }
    }
