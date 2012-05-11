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
  #   > [17:25:06] Jane Doe: Howdy! ...  
  #   > [17:26:10] John Doe: Oh! Hi Jane, nic...  
  #   > [17:28:28] John Doe: How's the weath...  
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
      # First find the time!
      (
        \[
          (\d{2}:\d{2}:\d{2})
        \]
      )
      # Time and the actual message are always seperated with a space!
      \s
      (
        # The message can be just a message ...
        (
          # so, we  have users name
          (.+)
          # which is seperated with a colon and a space
          :\s
          # from the message text (which runs across multiple lines)
          ([\s\S]+?)
        )
        # ... or we have a state change / sysex message
        |
        (
          # which starts with 3 asterix'
          (\*{3})\s
          (
            # and can be a new user by an existing user
            ((.+)\shat\s(.+?)\shinzu.+)
            |
            # or the topic has been changed by an existing user.
            ((.+)\shat\sdas\s(Thema).+\sin\s"(.+)")
          )
          # Afterwards the sysex closes with 3 asterix' again.
          \s\*{3}
        )
      )
      # As each message block is either followed by a line break and a new time
      # tag or the end of the string, we look ahead for it:
      (?=(\r\n\[\d{2}:\d{2}:\d{2}\])|$)
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

  # Whitelist of Values
  include = if platform_is_windows
    [
      2  # Date/Time
      5  # Username
      6  # Message
      8  # Sysex Token
      14 # Sysex User (Topic)
      15 # Sysex Topic Command
      16 # Sysex New Topic name
      11 # Sysex User (UserAdd)
      12 # Sysex UserAdd New Users name
    ]
  else
    [
      # Mac Whitelist to come
    ]

  _topics = []
  topics = []
  _users  = []
  users  = []
  # With the parser RegExp and the platform flag we can parse the message string,
  # build a collection object and return it.
  messages = while _result = parser.exec @
    # Start with some fresh vars:
    [time,user,message,token,command,newuser] = (new Array(7))

    # Retrieve the whitelisted parts from the hit
    res = (match for match,index in _result when index in include and match isnt undefined)
    if res.length is 3 # we have a normal message
      [time,user,message] = res
    else if res.length is 4 # we have a sysex message for new user
      [time,token,user,newuser] = res
    else if res.length is 5 # we have a sysex message for new topic
      [time,token,user,command,topic] = res

    # Parse the time
    time = Date.fromClockTime(time)

    # Update the users buffer
    if user and user not in _users
      users.push  {name:user,joined_on:time}
      _users.push user
    if newuser and newuser not in _users
      users.push  {name:newuser,joined_on:time}
      _users.push newuser

    # Update the topics buffer
    if topic? and topic  not in _topics
      topics.push {topic,since:time}
      _topics.push topic

    # If we do not have an actual message, we can continue
    continue unless message

    # else update the messages buffer
    res = {time,user,message,topic:topic ? ""}
    # END Matching Loop

  # Finally return the messages:
  return {users,topics,messages}



# ### Date.fromClockTime
# Adds a helper for the Date Object to be able to parse clock times.
# 
Date.fromClockTime = (time) ->
  # Start with the epoch and just pass in some 24h clock time
  return new Date(Date.parse "Thu, 01 Jan 1970 #{time} GMT-0000")
