## Description
This repository is a URL Shortener API on Rails, here you will find top 100 most visited sites and you can redirect to them.

## Requirements
The project was developed with Rails 6 with MariaDB, Redis, Resque and Docker. So, you need to have docker and docker compose on your machine.

First, you have to install Docker and Docker compose. Then you can clone this project and follow the next commands:

- Intial Setup
```
    docker-compose build
    docker-compose up mariadb
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build
```

Next, we need to run the DB migrations, this will be achived using the following commands:

- To run migrations
```
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare
```

Finally, you can start to use the API by running the following command:

```
    docker-compose up
```

If you want to run the specs, you might use the next command:

```
    docker-compose -f docker-compose-test.yml run short-app-rspec
```

If you want to test the API on curl you can do it accesing with the following curl commands

## Curl

- Adding a URL
```
    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json
```

- Getting the top 100
```
    curl localhost:3000
```

- Checking your short URL redirect
```
    curl -I localhost:3000/abc
```

## URL Algorithm Solution

Seaching about the best way to solve the problem of the algorithm, I have found that the best approach is by using the bijective function. It consists on converting a given ID (Type Integer) to base 62 (Type String), which contains characters in the ranges of 'a' to 'z', 'A' to 'Z' and '0' to '9'. Like so, we only store the minified url that points to that unique ID on the DB.
When a user enters the minified Url, the API is going to decode this minified url to find the full url on database by ID. Then, the API will redirect to the full url stored on the database if not will show a 404 error message.

Some URLS information which help me to solve it:
- https://stackoverflow.com/questions/742013/how-to-code-a-url-shortener
- https://www.geeksforgeeks.org/how-to-design-a-tiny-url-or-url-shortener/
- https://en.wikipedia.org/wiki/Bijection

## Background JOB
For this, I am using resque gem. Which is going to let me work with background jobs. The main porpuse of the 
BJ is to bring the title of each full URL and update the title of the object. 
 