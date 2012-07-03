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
  "[06.05.2009 17:27:04] kati gaedcke: oder ich hol mir ne pizza von aldi"

win_thema = "[20:27:50] *** kati gaedcke hat Linda hinzugefügt ***"+"\r\n"+
            "[20:28:26] *** kati gaedcke hat Gina hinzugefügt ***"+"\r\n"+
            "[20:28:36] kati gaedcke: hallo"+"\r\n"+
            "[20:28:59] *** kati gaedcke hat das Thema geändert in \"testkonversation\" ***"+"\r\n"+
            "[20:29:10] Linda: hallo"+"\r\n"+
            "[20:29:48] Linda: na Kati, wie gehts? Wo bist du?"+"\r\n"+
            "[20:30:07] kati gaedcke: hey linda! sitze hier auf deinem sofa! super nudeln!!!!!!"+"\r\n"+
            "[20:30:56] Linda: hihi, danke"+"\r\n"+
            "[20:31:12] Linda: also die Chinesen?"+"\r\n"+
            "oder ne wurst ?"+"\r\n"+
            "[20:31:16] kati gaedcke: hahaha"+"\r\n"+
            "[20:31:21] Linda: drei mit dem Kontrabass"+"\r\n"+
            "[20:31:42] kati gaedcke: ja, die saßen auf der Mauer oder?"+"\r\n"+
            "[20:31:54] Linda: ja ich glaube die erzählten sich auch was"+"\r\n"+
            "[20:32:13] kati gaedcke: jaja. drei chinesen auf dem kontrabass..."+"\r\n"+
            "[20:32:26] Linda: da kam doch noch die Polizei!"+"\r\n"+
            "[20:32:28] Linda: man..."+"\r\n"+
            "[20:32:36] Linda: ja was ist denn das?"+"\r\n"+
            "[20:35:31] kati gaedcke: 3 CHINESEN auf dem Kontrabass"+"\r\n"+
            "[20:35:48] Linda: hihi"
            
win_thema = "[20:27:50] *** kati gaedcke hat Linda hinzugefügt ***"+"\r\n"+
            "[20:28:36] kati gaedcke: hallo"+"\r\n"+
            "[20:28:59] *** kati gaedcke hat das Thema geändert in \"testkonversation\" ***"+"\r\n"+
            "[20:29:00] Linda: Noch ein test"+"\r\n"+
            "oder nicht?"+"\r\n"+
            "[20:29:10] Linda: hallo kati"+"\r\n"+
            "oder ne wurst?"+"\r\n"+
            "Nicht?"+"\r\n"+
            "[20:35:31] kati gaedcke: 3 CHINESEN auf dem Kontrabass"+"\r\n"+
            "[20:35:48] Linda: hihi"

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
  "users"
  "topics"
  "messages"
]

# ============================================================================
# = Specs                                                                    =
# ============================================================================
describe "The String prototype", ->
  it "should have picked up the Method", ->
    String.should.respondTo('parsefromSkype')

describe "Conversation from Windows Skype can be parsed", ->
  beforeEach ->
    @win = "[05:06:17] John Doe: Hello World".parsefromSkype()
    
  it "should return null on other text", ->
    "Test".parsefromSkype().should.be.null
    
  it "should not return null", ->
    @win.should.not.equal null
    
  it "should have required keys", ->
    @win.should.have.keys required_keys
    
  it "should return an array on proper input", ->
    @win.messages.should.be.instanceof Array
    
  it "should return an array of length 1 on simple input", ->
    @win.messages.should.have.length 1
    
  it "should have the Name", ->
    @win.messages[0].user.should.equal("John Doe")
    
  it "and should have the Message", ->
    @win.messages[0].message.should.equal("Hello World")
    
  it "which was posted on", ->
    expected_date = Date.fromClockTime "05:06:17"
    @win.messages[0].time.getTime().should.equal expected_date.getTime()


describe "Conversation parses and", ->
  beforeEach ->
    @win = win_thema.parsefromSkype()
      
  it "have the topic 'testkonversation'", ->
    @win.topics[0].name.should.equal "testkonversation"
    
  it "have the users", ->
    names = (user.name for user in @win.users)
    names.should.include name for name in ["kati gaedcke","Linda"]
    
  it "should have 4 messages", ->
    @win.messages.length.should.equal 4