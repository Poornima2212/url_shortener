# README

Build a simple URL shortening service using Ruby on Rails. The service should allow users
to do the following:
Requirements:
- Enter a long URL into a form.
- Submit the form and receive a shortened URL in return.
- Use the shortened URL to redirect to the original long URL.
- Expose an API with token for external web clients to create short URL
- Add 2 days expiry for the URL 
- Document the exposed API in swagger
- write spec for exposed API



The application should
- have a form for submitting long URLs.
- generate a unique shortened URL for each long URL submitted.
- store the long and shortened URLs in a database.
- redirect users to the original long URL when they visit the shortened URL.


API SERVER SETUP:

Download brew:

 `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" `


on succesive install of brew, we will have to run the below commands:

 
  `echo >> /Users/poornimaanantharaman/.zprofile  `

  `echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/poornimaanantharaman/.zprofile  `

  `eval "$(/opt/homebrew/bin/brew shellenv)" ` 


Install Rbenv to install ruby:

 `brew install rbenv `

 `rbenv instal 3.3.6 `

 `rbenv global 3.3.6 `

Copy below to ~bash_profile/zshrc:

 `export PATH="$HOME/.rbenv/bin:$PATH" `

 `eval "$(rbenv init -)" `

move to url_shortener repo:

 `sudo gem install bundler `

 `bundle i `

Start rails server:

 `rails s`
