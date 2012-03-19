###
Parse Messages from a Skype conversation in to a JSON Object

jens a. ewald, ififelse.net, 2012, licensed by the unlicence
###

String::parsefromSkype = ->
  #### Prepare the parser!
  # The parser must be different for Windows or Mac Version.
  # Linux is not tested yet.
  #
  # On Windows the input looks something like this:
  # 
  #   
  #   [06.05.2009 17:25:06] Jane Doe: Howdy! Nice to see you!
  #   [06.05.2009 17:26:10] John Doe: Oh! Hi Jane, nice weather today, isn't it
  #   [06.05.2009 17:28:28] John Doe: How's the weather in Australia?
  #   
  # 
  # The Mac Version gives you more this style:
  # 
  #   Jane Doe 28.10.11 12:31 
  #   Howdy! Nice to see you!
  #   John Doe 28.10.11 12:31 
  #   Oh! Hi Jane, nice weather today, isn't it
  #   28.10.11 12:31
  #   How's the weather in Australia?
  #
  # So, we can dissect it with two different RegExp
  # _Store the platform flag for later use!_
  #
  iswin = @.match /^\[\d{2}/
  parser = if iswin
    # #### The RegExp for Windows style messages
    ///
      # It Starts @ the begining or a Line ending with followed by Meta
      ( # Start capturing Meta Data
        \[ 
           # Date & Time
          ((\d{2}).(\d{2}).(\d{4}))
          \s
          ((\d{2})\:(\d{2})\:(\d{2}))
  
        \]\s # The date block ends
  
        # Get the name:
        (.*)
  
        \:\s # Between the name and the text is ": " as seperator
      ) # End of Meta
  
      # Get the Message up until the next meta
      (
        (.|(\r\n[^\[\d\.]{9}))+
      )
    ///g
  else
    # #### The RegExp for Mac style messages
    macparser = ///
      ( # The outer grouping is for (mostly) compatible postitions tp the Windows RegExp
        (
          (
            # Username
            (.*)
            \s
            # Date
            (
              (\d+)\.(\d+)\.(\d+)\s+(\d+):(\d+)
            )(?=\s|\n)
          )
          # The message itself follows
          (
            (.|(\n(?!.*\d{2}\.)))+
          )
        )
      )
    ///g
  
  # With the parser RegExp and the platform flag we can parse the message bulk, 
  # build a collection object and return it.
  while _result = parser.exec @
    # For each platform the resulting array is a bit different, so we
    # must collect from different poistions.
    keys = if iswin then [3,4,5,7,8,9,10,11] else [6,7,8,9,10,4,11]
    _res = (e for k,e of _result when parseInt(k) in keys)
    if iswin
      [d,mo,y,h,m,s,user,message] = _res
    else
      [user,d,mo,y,h,m,message]   = _res
      # **Warning! Unprecise stuff.** 
      # The Mac-Skype timestamp does not give us a full year. So we must guess.
      y = "20#{y}"
    # Finally build the block blob
    _blob =
      User: user || lastuser,
      Text: message,
      Zeit: new Date(y,mo,d,h,m,(s ? 0)) || lasttime,
      Komentar: ""
    # Keep last used unstable properties to use as fallback
    lastuser = _blob.User
    lasttime = _blob.Zeit
    # Return the converstation block to the collection
    _blob
