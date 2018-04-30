# VltLabsWizard

This is a simple app we built to help track project progress and resource expenditure in our development house, while evaluating and learning new technologies.

## Features
* Track employees
  * Departments
  * Assignment
* Track projects
  * Estimate timelines
  * Track resource usage
* Slack integration
  * Bot with time tracking reminders 
* REST API for all functionality
* Admin panel

## Dependencies
* Postgres
* AWS bucket

## Running

To start your Phoenix server:
  * Copy `.env.example` to `.env` and customize to your environment
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


