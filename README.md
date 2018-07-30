# README

"Things" is an example application to practice and demonstrate use of numerous technologies useful in a website.  

#### View Application
You may signup and sign in to view the running application, hosted on a t2.micro instance and free-tier RDS instance at AWS:

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

#### Background Jobs
Currently, the db:seed creates 10 Person instances and populates Species and ToyType with lookup values.  It then schedules multiple recurring jobs that make the system record the data for events including:
  * New Animal given to shelter
  * Animal gets adopted by Person
  * Animal that is already adopted is given a Toy
  * Oldest of adopted Animal dies, freeing up a position for a new AnimalAdoption

#### Dashboard
If you signup and sign in you can view the Dashboard to see counts of People, Animals, Adoptions, and Toys

#### Soft Delete Behavior
The system is set to disallow deletion of any actual database rows, and rather uses an is_deleted flag on each table.  This allows the log_data field on each row for each table to record and retain the full audit history of what data changed, when, and under whose authority.

#### Technologies used include:

* Ruby 2.5.x / Rails 5.2

* [react-rails](https://github.com/reactjs/react-rails) / React 16.x / Reactstrap 6.3.x

* rails-webpacker 3.x including SSR Server Side Rendering

* axios (for json get/put/patch)

* Atom editor with ES6 eslint and Rubocop

* Postgresql 10.4.x

* [Logidze](https://github.com/palkan/logidze) - Postgresql Trigger based audit trail - independent of ActiveRecord or any application layer processing logic

* [Auth0](https://auth0.com) - for hosted authentication / authorization including signup / signon via Google

* AWS EC2 Hosting via systemd and AWS RDS for Postgresql hosting

* [Overmind](https://github.com/DarthSim/overmind) - alternative to Foreman for Procfile usage

* [Delayed::Job](https://github.com/collectiveidea/delayed_job) and [delayed_job_recurring](https://github.com/amitree/delayed_job_recurring) - background job processing including recurring / scheduled jobs

#### Running locally

Due to the integration with Auth0, I have used `rails credentials:edit` to set values for the following variables.  The first time you execute this command it will create `config/secrets.yml` file which is excluded via .gitignore.  It also creates `config/credentials.yml.enc` which is included in git, but you will need to delete it and generate your own with the following information in order for this to work:

```
rails:
  secret_key_base: <make your own via `rails secret`>

auth0:
  client_id: <sign up for own free auth0.com and use your own key here>
  client_secret: <sign up for own free auth0.com and use your own secret here>
  domain: <use auth0 created domain like codebarn.auth0.com>
  dev_callback_url: http://localhost:5000/auth/auth0/callback
  prod_callback_url: https://<your-hosted-prod-site>/auth/auth0/callback
```

#### Future Ideas

Items that I will continue to chip away at:

* Full CRUD screens for all Models (currently only allow Add/Edit of Animal which is enough to demonstrate React and show the Logidze audit trail values associated with Animal creation and edits.

* Unit Testing

* Selenium Integration Testing

* Permissions / Roles (i.e. Administrator, PetAdopter, etc.)

* ActiveStorage image and attachment storage

* CI/CD for automated deploy (currently just deploying manually via ssh into EC2 instance and pulling latest code via git)
