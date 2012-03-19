###
Some Tests follow...
###

tw =
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
tm = 
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

console.log JSON.stringify(tw.parsefromSykpe(),null,2)
console.log "***********************"
console.log JSON.stringify(tm.parsefromSykpe(),null,2)
