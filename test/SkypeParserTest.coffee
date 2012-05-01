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
  "[06.05.2009 17:25:42] kati gaedcke: ne wurst ?"+
  "\r\n"+"oder ne wurst ?"+"\r\n"+
  "[06.05.2009 17:25:43] kati gaedcke: :)"+"\r\n"+
  "[06.05.2009 17:26:12] simone sch.: neee ich weis net woher denn ... und dann dauert das ja so lang bis wir die drauf haben oder"+"\r\n"+
  "[06.05.2009 17:26:23] kati gaedcke: hmm"+"\r\n"+
  "[06.05.2009 17:26:35] simone sch.: ich denk dann haben wir um 8 was zum essen ...."+"\r\n"+
  "[06.05.2009 17:26:48] kati gaedcke: hmm.. dann lassen wir das"+"\r\n"+
  "[06.05.2009 17:27:04] kati gaedcke: oder ich hol mir ne pizza von aldi";

win_thema = """[20:27:50] *** kati gaedcke hat Linda hinzugefügt ***
[20:28:26] *** kati gaedcke hat Gina hinzugefügt ***
[20:28:36] kati gaedcke: hallo
[20:28:59] *** kati gaedcke hat das Thema geändert in "testkonversation" ***
[20:29:10] Linda: hallo
[20:29:48] Linda: na Kati, wie gehts? Wo bist du?
[20:30:07] kati gaedcke: hey linda! sitze hier auf deinem sofa! super nudeln!!!!!!
[20:30:56] Linda: hihi, danke
[20:31:12] Linda: also die Chinesen?
[20:31:16] kati gaedcke: hahaha
[20:31:21] Linda: drei mit dem Kontrabass
[20:31:42] kati gaedcke: ja, die saßen auf der Mauer oder?
[20:31:54] Linda: ja ich glaube die erzählten sich auch was
[20:32:13] kati gaedcke: jaja. drei chinesen auf dem kontrabass...
[20:32:26] Linda: da kam doch noch die Polizei!
[20:32:28] Linda: man...
[20:32:36] Linda: ja was ist denn das?
[20:35:31] kati gaedcke: 3 CHINESEN auf dem Kontrabass
[20:35:48] Linda: hihi
"""
  
mac = """Chris Engler 28.10.11 12:31 
:)
28.10.11 12:31
ja dann
jens.a.e 28.10.11 12:31 
mit dynamic pins isse nicht so geil
Chris Engler 28.10.11 12:31 
brauchst du mich ja nicht
28.10.11 12:31
no"""


require("../src/SkypeParser")

chai = require 'chai'
should = chai.should()
expect = chai.expect


required_keys = [
  "Zeit"
  "User"
  "Text"
  "Kommentar"
  "Thema"
]

# ============================================================================
# = Specs                                                                    =
# ============================================================================
describe "The String prototype", ->
  it "should have picked up the Method", ->
    String.should.respondTo('parsefromSkype')


describe "Utils", ->
  it "should be able to retrieve the topic", ->
    s = "[20:28:59] *** kati gaedcke hat das Thema geändert in \"testkonversation\" ***"
    expect(s.getSkypeTopic()).to.equal "testkonversation"


describe "Conversation from Windows Skype can be parsed", ->
  beforeEach ->
    @parsed = win_thema.parsefromSkype()
  it "should not return null", ->
    @parsed.should.not.have.length 0
  it "should not return null", ->
    @parsed[0].should.have.keys required_keys


describe "Conversation parses and", ->
  beforeEach ->
    @win = "[05:06:17] John Doe: Hello World".parsefromSkype()
  
  it "should return null on failed parsing", ->
    "Test".parsefromSkype().should.be.null
    
  it "should return an array on proper input", ->
    @win.should.be.instanceof Array

  it "should return an array of length 1 on simple input", ->
    @win.should.have.length 1

  it "should return an object with correct keys", ->
    @win[0].should.have.keys required_keys
    
  it "have the topic 'testkonversation'", ->
    res = win_thema.parsefromSkype()
    res[0].Thema.should.equal "testkonversation"
    