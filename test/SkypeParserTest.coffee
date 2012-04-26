###
Specs for SkypeParser using mocha with Chai
-------------------------------------------
Do: npm install mocha chai
Run: mocha --compilers coffee:coffee-script -w -R spec
###

win =
  "[06.05.2009 17:25:06] simone sch.: ICH MAG KEIN SUBWAYS"+"\r\n"+
  "[06.05.2009 17:25:22] kati gaedcke: oder wir holen uns ne wurst für den grill hier"+"\r\n"+
  "[06.05.2009 17:25:33] simone sch.: ES GIBT JA SONST NIX"+"\r\n"+
  "[06.05.2009 17:25:42] kati gaedcke: ne wurst ?"+"\r\n"+"oder ne wurst ?"+"\r\n"+
  "[06.05.2009 17:25:43] kati gaedcke: :)"+"\r\n"+
  "[06.05.2009 17:26:12] simone sch.: neee ich weis net woher denn ... und dann dauert das ja so lang bis wir die drauf haben oder"+"\r\n"+
  "[06.05.2009 17:26:23] kati gaedcke: hmm"+"\r\n"+
  "[06.05.2009 17:26:35] simone sch.: ich denk dann haben wir um 8 was zum essen ...."+"\r\n"+
  "[06.05.2009 17:26:48] kati gaedcke: hmm.. dann lassen wir das"+"\r\n"+
  "[06.05.2009 17:27:04] kati gaedcke: oder ich hol mir ne pizza von aldi";

win_thema = 
  
mac = 
  """Chris Engler 28.10.11 12:31 
:)
28.10.11 12:31
ja dann
jens.a.e 28.10.11 12:31 
mit dynamic pins isse nicht so geil
Chris Engler 28.10.11 12:31 
brauchst du mich ja nicht
28.10.11 12:31
no"""


# String::parsefromSkype = require("../src/SkypeParser").parsefromSkype
require("../src/SkypeParser")

chai = require 'chai'
should = chai.should()
expect = chai.expect


describe "The String prototype", ->
  it "should have picked up the Method", ->
    String.should.respondTo('parsefromSkype')

describe "Conversation parses and", ->
  beforeEach ->
    @win = "[01.02.3004 05:06:17] John Doe: Hello World".parsefromSkype()
    @win_topic = "[01.02.3004 05:06:17] John Doe: Hello World".parsefromSkype()
  
  it "should return null on failed parsing", ->
    "Test".parsefromSkype().should.be.null
    
  it "should return an array on proper input", ->
    @win.should.be.instanceof Array

  it "should return an array of length 1 on simple input", ->
    @win.should.have.length 1

  it "should return an object with correct keys", ->
    @win[0].should.have.keys [
      "Zeit"
      "User"
      "Text"
      "Kommentar"
      "Thema"
    ]
