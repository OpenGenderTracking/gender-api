A very simple API to get gender probability on a name and/or article. 

It uses Stanford NER, version 3.2.0.  Stanford NER is a package that provides a high-performance machine learning based named entity recognition system, incluidng facilities to train models from supervised training data and pre-trained models for English. The software is licensed under full GPL. You can find the software in lib/ner/

The name's gender is recognized based on estatical census data from US and UK.

## USAGE

This is a sinatra app. To run it locally:


    'bundle install'
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
        "Maria": {
            "first": null,
            "surname": "Maria",
            "count": 1,
            "gender": "female"
        },
        "Anne": {
            "first": null,
            "surname": "Anne",
            "count": 1,
            "gender": "female"
        }
    }


## LICENSE

The software is licensed under the GPL.  Please see the file LICENCE.txt


## CONCEPTION

This API was concieved during MozFest 2013 London, at Nathan Matia's 3 hours workshop "Measuring the News: Tracking Content and Engagement". Notes for the session on https://festival.etherpad.mozilla.org/journalism_measuring-the-news-tracking-content-and-engagement
