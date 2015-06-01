# Heroku deployment
Now that you've created a super cool web app, you want to show the world (see: employers) your skills! (The world needs to know about Conz's Cool Comments!!!!)

## Summary
1. Install Heroku toolbelt
2. `heroku login`
3. `heroku keys:add`
  - `rm ~/.ssh/id_*` when on the office computers
4. `git remote add heroku heroku-git-url-here` OR `heroku git:remote -a heroku-app-name-here`
5. `gem 'rails_12factor'`
6. `git push heroku master`
  - `heroku run bundle exec rake db:migrate`
7. [Pingdom][7]

## 1. Heroku toolbelt
First, if you haven't already, install the Heroku toolbelt onto your computer, which allows you to run Heroku commands from the terminal. There are two ways to install:

1. via MacPorts `sudo port install heroku`
2. via [direct download file] [1]
[1]: https://toolbelt.heroku.com

## 2. Logging into Heroku
[Create an account][2] if you haven't already. Log in from the command line with `heroku login`.
[2]: https://heroku.com

## 3. SSH Keys
You need to make sure that the SSH keys on the computer you're using are in your account. If you're using a **public computer**, i.e. one of the computers in the office, you'll want to remove the existing keys because SSH keys may only be associated with one account, while an account can have multiple SSH keys. (SSH key `belongs_to :user`; User `has_many :ssh_keys`)

On the office computers, wipe out the current SSH keys with `rm ~/.ssh/id_*`. Then run `heroku keys:add`, which automatically generates a new key and uploads it to your account. You can see all of the SSH keys associated with your account on Heroku under [Account][3].
[3]: https://dashboard.heroku.com/account

If you're on your **personal computer**, you don't want to delete your keys because they're most likely connected to your Github, so all you'll need to do is `heroku keys:add` if you haven't already added your keys.

## 4. Creating your Heroku app
On Heroku, click on the "+" in the top righthand corner to create a new app. After you've created the app, copy the Git URL (located under 'Settings') and paste it to the end of this command (in place of "your-heroku-git-url-here"):

```bash
git remote add heroku your-heroku-git-url-here
```

(This should look familiar!)

This Heroku command also does the same thing with the name of your Heroku app:

```bash
heroku git:remote -a heroku-app-name-here
```

Don't worry too much about naming your app because you can always go back later and rename it in "Settings" on your app dashboard. However, if you do rename your app, you need to make sure to also change the url to the remote! (`git remote set-url heroku new-heroku-git-url-here`)

## 5. Serving assets
Remember to include the [rails_12factor gem][4] in your Gemfile under the production group!
[4]: https://github.com/heroku/rails_12factor

```ruby
group :production do
  gem 'rails_12factor'
end
```

By default, Rails will not serve your asset files because it assumes that you'll host them on a separate CDN (content delivery network, like [AWS][5]). Because we want Heroku to serve up our local javascript files and stylesheets, this gem will allow that to happen. 
[5]: http://aws.amazon.com

`rails_12factor` also provides your production server logs with detailed errors you're used to getting in your development logs.

Your friends:
```html+erb
<img src="<%= asset_path('spacecat.jpg') %>">
```

```scss
// Make sure you're using a .SCSS file!

div {
  background-image: image-url("spacecat.jpg");
}
```

## 6. Pushing to Heroku
```bash
git push heroku master
```

Just like pushing to Github!

During the push, Heroku is creating the database (if it hasn't already been created) and bundle installing. Therefore, you never have to run those commands manually for Heroku.

If you have any new migrations (especially on your first time pushing to Heroku), you need to make sure you migrate: `heroku run rake db:migrate`. Every time you make a new migration locally, do not forget to migrate on the production side as well!

If you want to use your seed file in production, `heroku run rake db:seed`.

Other useful commands:
- `heroku run rails c`: Rails console in the production environment. Be careful making any changes here because they will apply to your live website!
- `heroku logs` / `heroku logs -t`: Your Heroku server logs, so you can see the activity on your site. If you have "rails_12factor" installed, you will also get error displays, which is super useful in figuring out what might be causing parts of your site to be down. `heroku logs` will just display the most recent activity, while `heroku logs -t` will show you live coverage, exactly as the rails server does on localhost.

The [Heroku docs][6] have many other helpful tips!
[6]: https://devcenter.heroku.com/

## 7. Pingdom
Last but not least, Heroku will spin down your server if there isn't any activity in the last 30 minutes. Therefore, when someone visits your site after 30 minutes of inactivity, it will take much longer to load, which would be unfortunate if that someone was an employer, who most likely won't have the patience for or be particularly impressed with a slow-loading website.

To avoid this problem, register your site with [Pingdom][7]! It is free and will make requests to your site every five minutes so that Heroku won't put your site to sleep.

[7]: https://www.pingdom.com/free/
