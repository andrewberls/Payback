# Welcome to Payback.

Payback is a free app to help you track expenses with your friends and roommates. You don't have to remember who owes you money, when you lent it, or who's already paid you back. Just let Payback know and it will remember all the details for you! The site is designed with phones in mind, and looks great for when you're on the go.

## How does it work?
### Sign Up
Getting started with Payback is simple. Once you've signed up for an account, you can create groups to track your expenses. With a simple ID and password, your friends can join your group and get started instantly.

### Start Spending
Adding expenses to Payback is easy. You can select whether you want to divide the amount among all members of a group, or just a few. You're given two options when adding a new expense - Split Evenly or Payback, which determines how the cost will be split. That's all there is to it! Payback will take care of all the math for you, and never forgets.

### Can I contribute?
Of course! Pull requests and suggestions are more than welcome. There's always work to be done and improvements to be made, and I welcome any input. I'm sure I'll get around to creating a wiki with more extensive notes later, but here's a the tl;dr version of the todo list:

+ Facebook integration - signup and friend invitations (unfortunately must be done)
+ Group chat (tech demo more than anything - see redis branch)
+ I should probably write some actual tests at some point.


### Quickstart
Payback runs on Rails 3.1 and uses sqlite in development. Assets are handled through SCSS and CoffeeScript.

```
git clone git@github.com:andrewberls/Payback.git
bundle install
rake db:setup
rails server
```
