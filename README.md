# HipBot

A simple, expandable paranoid android for HipChat. Written in Node.js.

He does your bidding even with his failed prototype of Sirius Cybernetics Corporation's GPP (Genuine People Personalities) technology.

It was written as a way for me to learn Coffeescript and Node.js and is based heavily off of [wobut](https://github.com/cjoudrey/wobot), [evilbot](https://github.com/defunkt/evilbot), and [robut](https://github.com/justinweiss/robut). It should very much be considered a toy but feel free to help make it better and point out my mistakes!

### Currently HipBot knows:
   
  - Basic Personality (feelings, robot laws, etc)  `@marvin the laws`
  - Current Weather Forecast by Zip `@marvin weather in ZIP`
  - Find a Wikipedia page `@marvin wiki me TOPIC`
  - Google Image search  `@marvin image me PHRASE`
  - LOLcats `@marvin lolcat me`
  - FailBlog `@marvin failblog me`
  - XKCD comic `@marvin xkcd me`
  - Respond with _That's What She Said_ when appropriate through the [TWSS](https://github.com/bvandenbos/twss) ruby gem.


## Installation

HipBot is written in Node.js using coffeescript. 

** I will add it to npm as soon as I can streamline the install process a bit and jsdom is updated.

It also relies on [node-xmpp](https://github.com/astro/node-xmpp) which I had trouble getting to run on OS X. It works flawlessly on Ubuntu though.

I use Vagrant on OS X to boot up an Ubuntu vbox.

Also note that node-xmpp requires:

- libexpat1-dev: `apt-get install libexpat1-dev`
- libicu-dev: `apt-get install libicu-dev`

To install make sure you have [npm](https://github.com/isaacs/npm) installed:

    git clone git@github.com:particlebanana/hipbot.git
    cd hipbot
    npm install
    
#### Note: 
Some plugins require the latest version of [jsdom](https://github.com/tmpvar/jsdom) from github. When 2.0.1 is released you will be able to install via npm for now follow the directions [here](https://github.com/tmpvar/jsdom/blob/master/README.md).

You will need to configure the settings in `hipbot.coffee` with you xmpp connection information you get from hipchat.
 
## Usage

I named the bot marvin based on [Marvin the Paranoid Android](http://en.wikipedia.org/wiki/Marvin_the_Paranoid_Android) from the The Hitchhiker's Guide to the Galaxy.

To see a list of commands Marvin can execute send: `@marvin help` in the chatroom. He also responds to some basic personality request and my personal favorite `@marvin the laws`.

## The Bot Brain

The core file is `hipbot.coffee` which loads all the connection options and autoloads the bots skills. All the logic is done in `/lib/brain.coffee`. This needs work.

## Bot Ninja Skills

HipBot has pluggable skills that can be added by creating a new skill file in `/skills`. These files are autoloaded so to remove a skill you must remove the file. I plan on making this a config option eventually.

Skills are simply functions that are triggered with the onMessage event. In order for your skill to display in the `help` command you must include a `desc` function.

#### Example:

    // exports the function
    module.exports.load = (bot) ->
      bot.desc 'hello world', 'returns Hello World'
      bot.onMessage '@marvin hello world', helloWorld

    // sends a message to the current chatroom
    helloWorld = (channel, from, message) ->
      @message channel, 'Hello World'
      true


### Shell Scripts

Some skills may require you to execute shell scripts. An example of this is included with the TWSS (Thats What She Said) skill. It uses the ruby gem [twss](https://github.com/bvandenbos/twss) through the Node spawn command to execute a shell script. 

Any external scripts needed for new skills should be added to the `/tools` folder. To use them create symlink to somewhere in you PATH so that HipBot can have access to them through the command line.