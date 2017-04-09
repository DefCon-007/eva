# Description:
#  Welcome new members to the group and respond to small talk.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  hello - Responds with a cheery message
#  hi - Same as hello
#  how are you - Responds with a polite greeting
#  send the joining message to me - Responds with the joining message that is sent to users when they first join this slack
#  tell me more about <channel-name> - Send long description containing information about the channel
#
#
# Author:
#  nevinvalsaraj
#  icyflame
welcome_message_1 = [
  "Hi ",
  "Hola ",
  "Hey ",
  "Hey there, "
]

welcome_message_2 = [
  "! Looks like you're new here.",
  "! Looks like this is your first time here.",
  "! Welcome to MetaKgp!",
]

welcome_message_3 = [
  " Why don't you introduce yourself?",
  " Why don't you tell us a bit about you?"
]

welcome_message_4 = " Also it will be better if you update your slack profile with your real name,contact number etc. "
channels_info = [
  "Hello, welcome to Metakgp's Slack!",
  "The following is a list of channels and the type of discussions  that each channel is designed to contain:",
  "- #mfqp-source -> Discussions about the mfqp-source project",
  "- #meta-x -> Disussions related to ongoing meta-x projects (naarad, mfqp, mftp, mcmp) and future moonshots",
  "- #book-club -> Read a book that you want to talk about? Want to read a book that someone else talked about? Go here!",
  "- #server -> Server related discussion. We run a Digital Ocean droplet",
  "- #general -> General discussions that don't fit anywhere else",
  "- #cute-animal-pics -> `@eva cat bomb 4` or `@eva pug bomb 4` in this channel should tell you more!",
  "- #random -> Unrelated rants and discussions, anything really\n\n",
  "GitHub: https://github.com/metakgp",
  "Wiki: https://wiki.metakgp.org"
].join('\n')

channel_descriptions = JSON.parse require("fs").readFileSync("channel_long_descriptions.json")
sorry_no_information = "Ooops! It seems we don't know anything more about this channel! Sorry, you are a pioneer!"

plugin = (robot) ->
  robot.respond /(hello|hi)/i, (msg) ->
      msg.send "Hi @#{msg.message.user.name}!"

  robot.respond /how are you/i, (msg) ->
    msg.send "Things are good, @#{msg.message.user.name}! What about you?"

  robot.respond /(send the )?joining message( to me)?/i, (msg) ->
    robot.send {room: msg.message.user.name}, channels_info

  robot.respond /(tell me )?more about \#?([a-z-]+)/, (msg) ->
    channel_name = msg.match[2]
    channel_more_info = sorry_no_information
    if channel_descriptions[channel_name]
      channel_more_info = channel_descriptions[channel_name]
    robot.send {room: msg.message.user.name}, channel_more_info

  robot.enter (msg) ->
    if msg.message.room == "general"
      robot.send {room: msg.message.user.name}, channels_info
      randNum = Math.floor(Math.random() * 10)
      msg.send welcome_message_1[randNum % (welcome_message_1.length-1)] + \
        '@' + msg.message.user.name + welcome_message_2[randNum % \
          (welcome_message_2.length-1)] + welcome_message_3[randNum % \
            (welcome_message_3.length-1)] + welcome_message_4 
    else
      robot.send {room: msg.message.user.name}, "Hey #{msg.message.user.name}, You just joined ##{msg.message.room}, here's some information about this channel!"
      more_about_the_channel = sorry_no_information
      if channel_descriptions[msg.message.room]
        more_about_the_channel = channel_descriptions[msg.message.room]
      robot.send {room: msg.message.user.name}, more_about_the_channel

module.exports = plugin
