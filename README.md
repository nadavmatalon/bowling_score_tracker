#Bowling Score Tracker

## Table of Contents

* [Screenshot](#screenshot)
* [General Description](#general-description)
* [How to Install and Run](#how-to-install-and-run)
* [Browsers](#browsers)
* [Testing](#testing)
* [License](#license)


##Screenshot

<div width="400px" >
  <a href="https://raw.githubusercontent.com/nadavmatalon/bowling_score_tracker/master/public/images/bowling_screenshot.png">
    <img src="/public/images/bowling_screenshot.png" width="500" height="400px" style="border: 1px, solid, black"/>
  </a>
</div>


##General Description

This app implements a 10-pin bowling score tracker for up to 4 players.

* The back-end logic of the app is written in 
[Ruby](https://www.ruby-lang.org/en/) (2.1.1).
* The front-end interface
is written in [JavaScript](http://en.wikipedia.org/wiki/JavaScript) &amp; 
[jQuery](http://jquery.com).
* Code created according to [TDD](http://en.wikipedia.org/wiki/Test-driven_development) 
(testing with [Rspec](http://rspec.info/) &amp; 
[Capybara](https://github.com/jnicklas/capybara)).
* The app uses the [Sinatra](http://www.sinatrarb.com/) framework 
and [Thin Webserver](https://github.com/macournoyer/thin/).

For those who aren't familiar with the game, a comprehensive description 
of the rules and scoring can be found at: 
[Wikipedia on 10-Pin Bowling](http://en.wikipedia.org/wiki/Ten-pin_bowling)


##How to Install and Run

To install the app, __clone the repo__ to a local folder and then run the 
following commands in terminal:

```
$> cd bowling_score_tracker
$> bundle install
```

Then you'll need to create an __enviromental variable__ in your machine 
for [Sinatra](http://www.sinatrarb.com/)'s `session secret key`.

The name of this env variable should be: BOWLING_SECRET, and you 
can give it any value you like.

If you want a random string for this variable's value, you can 
use the following commands in terminal to generate it:

```
$> irb
#> SecureRandom.hex(64)
$> exit
```

Once the env variable for the session secret is set, you can run the 
local server:

```
$> thin start
```

Then open the browser of your choice and go to this address:

```
http://localhost:3000/
```


##Browsers

This app has been tested with and supports the following browsers (though
it should hopefully look decent in other browsers as well):

* __Google Chrome__ (39.0)
* __Apple Safari__ (7.1.2)
* __Mozilla Firefox__ (33.1)


##Testing

Unit and feature tests for the back-end logic and front-end interface 
were written with [Rspec](http://rspec.info/) (3.1.7) &amp;  
[Capybara](https://github.com/jnicklas/capybara) (2.4.1)).

To run the tests, clone the repo to a local folder and then run:

```bash
$> cd bowling_score_tracker
$> bundle install
$> rspec
```

##License

<p>Released under the <a href="http://www.opensource.org/licenses/MIT">MIT license</a>.</p>
