### 
# Parse Messages from a Skype conversation in to a JSON Object.
# jens a. ewald, ififelse.net, 2012, licensed by the unlicence
###

String::parsefromSkype = ->
  # The parser must be different for Windows or Mac Version.  
  # Linux is not tested yet.
  #
  # On Windows the input looks something like this:
  # 
  #   > [06.05.2009 17:25:06] Jane Doe: Howdy! ...  
  #   > [06.05.2009 17:26:10] John Doe: Oh! Hi Jane, nic...  
  #   > [06.05.2009 17:28:28] John Doe: How's the weath...  
  # 
  # The Mac Version gives you more this style:
  # 
  #   > Jane Doe 28.10.11 12:31  
  #   > Howdy! Nice to see you!  
  #   > John Doe 28.10.11 12:31  
  #   > Oh! Hi Jane, nice weather today, isn't it  
  #   > 28.10.11 12:31  
  #   > How's the weather in Australia?  
  #
  
  # _Store the platform flag for later use!_
  # So, we can dissect it with two different RegExp.
  platform_is_windows = @.match /^\[\d{2}/
  
  # #### The RegExp for Windows style messages
  parser = if platform_is_windows
    ///
      # First a meta information, then the actual message
      (
        \[ 
        # Date
          ((\d{2}).(\d{2}).(\d{4}))
          \s
        # Time
          ((\d{2})\:(\d{2})\:(\d{2}))
        \]\s
      # The Username
        (.*)
      # _(Between the name and the text is ": " as a seperator)_
        \:\s
      )
      # The message text runs until the end or a new line with meta
      (
        (.|(\r\n[^\[\d\.]{9}))+
      )
    ///g
  else
    # #### The RegExp for Mac style messages
    ///
      (
        (
          # Meta information
          (
            # Username
            (.*)\s
            # Date
            (
              (\d+)\.(\d+)\.(\d+)\s+(\d+):(\d+)
            )
            (?=\s|\n)
          )
          # The message itself
          (
            (.|(\n(?!.*\d{2}\.)))+
          )
        )
      )
    ///g
  
  # With the parser RegExp and the platform flag we can parse the message string, 
  # build a collection object and return it.
  while _result = parser.exec @
    # For each platform the resulting array is a bit different, so we
    # must collect from different positions.
    keys = if platform_is_windows then [3,4,5,7,8,9,10,11] else [6,7,8,9,10,4,11]
    _res = (e for k,e of _result when parseInt(k) in keys)
    if platform_is_windows
      [d,mo,y,h,m,s,user,message] = _res
    else
      [user,d,mo,y,h,m,message]   = _res
      # **Warning! Unprecise stuff.** 
      # The Mac-Skype timestamp does not give us a full year. So we must guess.
      y = "20#{y}"
    
    topic = topic ? ""
    
    # Finally we can build a new object
    _conversation_partial =
      User: user || lastuser,
      Zeit: new Date(y,mo,d,h,m,(s ? 0)) || lasttime,
      Text: message,
      Kommentar: ""
      Thema: topic || lasttopic
    
    # Keep last used unstable properties as fallback properties
    lastuser  = _conversation_partial.User
    lasttime  = _conversation_partial.Zeit
    lasttopic = _conversation_partial.Thema
    
    # Return the parsed object
    _conversation_partial
