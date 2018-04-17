# ShitpostBot
An LSTM neural network based chat bot that uses discordrb. This bot is by no means complete, but it is currently in a somewhat working state.

## Features
Currently, the character-based version of this bot is able to train itself to speak something like a member of your server. As a server administrator, you are able to configure how the bot replies in any of your various channels. You can set the bot to reply, say, 10% of the time that someone posts, every time someone posts, post only when mentioned, and even set it up to post its own, original thoughts, independent of any input from your users. Of course, you can also set the bot so that it does not post at all in any or all of your channels.

Although the documentation and code is, obviously, in English, this bot is actually language agnostic. Although I have not yet had the chance to train this bot in any non-English discord servers, it is able to train itself to speak in any language.

## Setup
todo
## Commands
- info
    - `help`
    - `about`
    - `stats`
- training
    - `train`
    - `read`
    - `readall`
    - `fullreadall`
    - `scrape`
- settings
    - `checkpoint`
    - `reply`
    - `mention`
    - `think`
    - `temperature`
    - `default`
    - `disable`
    - `settings`
- other
    - `checkpoints`
    - `finish`
## To-Do / Upcoming Features
- finish this readme
- figure out a solution for word-rnn-tensorflow (since it uses so much vram)
- add symbols (an unused character represents a user / channel / emoji)
- once symbols are done, add imitation (bot can imitate a user) and mentioning (bot can mention a user)

# Acknowledgments
- [Andre Karpathy](https://github.com/karpathy) for [char-rnn](https://github.com/karpathy/char-rnn)
- [Justin Johnson](https://github.com/jcjohnson) for [torch-rnn](https://github.com/jcjohnson/torch-rnn)
- [hunkim](https://github.com/hunkim) for [word-rnn-tensorflow](https://github.com/hunkim/word-rnn-tensorflow)
- [Kristupas Savickas](https://github.com/KristupasSavickas), because I got the structure, and some reused code, from [sapphire_bot](https://github.com/KristupasSavickas/sapphire_bot)
