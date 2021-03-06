# README

"Things" is an example application to practice and demonstrate use of numerous technologies useful in a website.

#### View Application
You may view the running application, hosted on a t2.micro instance (automatically started via systemd scripts) and free-tier RDS Postgresql instance at AWS:

https://things.codebarn.com

#### Inspiration / Tutorials

I used a number of web posts to guide this including but not limited to:

* [Evil Martians - web component and webpacker alternative to Rails Asset Pipeline](https://evilmartians.com/chronicles/evil-front-part-1)
* [Evil Martians - database enforced audit trail](https://evilmartians.com/chronicles/introducing-logidze)

#### Database Models
  * Person - can adopt up to two Animals
  * Animal - can be unadopted (at shelter) or adopted, and can own multiple Toys, and is of type Species
  * AnimalAdoption - intermediate table to store date of adoption of Animal by a Person
  * Toy - Toy owned by Animal or lost (deleted) and unowned
  * ToyType - Type of Toy
  * Species - List of possible Animal species

![image](https://user-images.githubusercontent.com/953248/43428501-2ce873ca-9424-11e8-94e9-e379c073f8c4.png)

#### Background Jobs
Currently, the db:seed creates 10 Person instances and populates Species and ToyType with lookup values.  It then schedules multiple recurring jobs that make the system record the data for events including:
  * New Animal given to shelter
  * Animal gets adopted by Person
  * Animal that is already adopted is given a Toy
  * Oldest of adopted Animal dies, freeing up a position for a new AnimalAdoption

#### Dashboard
View the Dashboard to see counts of People, Animals, Adoptions, and Toys with automatic refresh as the background jobs cause Animals to be added to shelter, adopted, receive a random toy, or perish.

#### Soft Delete Behavior
The system is set to disallow deletion of any actual database rows, and rather uses an is_deleted flag on each table.  This allows the log_data field on each row for each table to record and retain the full audit history of what data changed, when, and under whose authority.

#### Technologies used include:

* Ruby 2.6.1 / Rails 5.2.2

* [react-rails](https://github.com/reactjs/react-rails) / React 16.x / Reactstrap 7.x

* [rails-webpacker 4.x](https://github.com/rails/webpacker.git) including SSR Server Side Rendering

* axios (for json get/put/patch)

* Atom editor with ES6 eslint and Rubocop

* Postgresql 11.x

* [Logidze](https://github.com/palkan/logidze) - Postgresql Trigger based audit trail - independent of ActiveRecord or any application layer processing logic

* AWS EC2 Hosting via systemd and AWS RDS for Postgresql hosting

* [Overmind](https://github.com/DarthSim/overmind) - alternative to Foreman for Procfile usage

* [Delayed::Job](https://github.com/collectiveidea/delayed_job) and [delayed_job_recurring](https://github.com/amitree/delayed_job_recurring) - background job processing including recurring / scheduled jobs

* [react-reduction](https://github.com/reduction-admin/react-reduction) - React and Bootstrap4 styling example to improve appearance

* [Slack API](https://api.slack.com/#read_the_docs) - Add /things as custom command in private Slack workspace to retrieve same statistics available on https://things.codebarn.com/dashboard, as well as to cause test email to be sent via postmarkapp.com API

* [Postmark Transactional Email](https://postmarkapp.com/developer) - Use postmarkapp.com API to deliver transactional email such as shipping notifications, receipts, etc.

#### Running locally

I have used `rails credentials:edit` to set values for connecting to AWS RDS Postgres on production.  In development and test, you can just install Postgres.app for Mac or other normal way on Linux.

You will need to generate your own credentials file to run locally.  Execute `rails credentials:edit` and it will create `config/secrets.yml` file which is excluded via .gitignore.  It also creates `config/credentials.yml.enc` which is included in git, but you will need to delete it and generate your own with the following information in order for this to work:

```
rails:
  secret_key_base: <redacted>

aws:
  access_key_id: <redacted>
  secret_access_key: <redacted>
  rds_host: <redacted>
  rds_username: <redacted>
  rds_password: <redacted>

postmark:
  api_token: <redacted>
  webhook_url: /<redacted>/postmark/webhook
  inbound_url: /<redacted>/postmark/inbound

slack:
  app_id: <redacted>
  client_id: <redacted>
  client_secret: <redacted>
  signing_secret: <redacted>
  deprecated_verification_token: <redacted>
  webhook_url: /<redacted>/slack/webhook
```

#### Future Ideas

* Full CRUD screens for all Models (currently only allow Add/Edit of Animal which is enough to demonstrate React and show the Logidze audit trail values associated with Animal creation and edits.

* Unit Testing

* Permissions / Roles (i.e. Administrator, PetAdopter, etc.)

* Selenium Integration Testing

* ActiveStorage image and attachment storage

* CI/CD for automated deploy (currently just deploying manually via ssh into EC2 instance and pulling latest code via git)
