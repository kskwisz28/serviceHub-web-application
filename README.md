---
topic: Ruby on Rails Hello World
languages:
  - ruby
products:
  - Azure App Service
  - Azure Web Apps
---

# ServiceHub

This is a tool meant for TF's internal sales teams.  The source data comes from a series of Excel spreadsheets that are pushed to Mongo as part of a nightly ETL task.

There are two roles, one deals with upfront sales and the other role deals with servicing instruments.

## Databases
This app uses two MongoDB databases.  The default database is called "prod" and contains data exported frmo Excel spreadsheets.  The second database, "service_hub" contains app-specific data, such as the users and instruments resources.

## Countries
This app uses a static JSON file for the list of countries that the user can select.

It also uses the countries gem and money gem in order to display the correct currency symbol for each price.


## Populating the Instruments Collection
The Instruments collection is the most important collection for the ServiceHub app. It contains documents that combine data from many different Excel spreadhseets.  These spreadsheets have been imported to the Mongo `prod` database.

To popupulate or update the Instruments collection, you can either run the following rake task or navivate to `/populate_instruments/new` in your browser.

```
$ bundle exec rake instruments:populate
```

This is essentially a part II for the ETL job that exports data from Excel.  It combines disparate data into a single document for each instrument.

During the first iteration, it takes approximately 90 minutes to generate 402 instruments.

The philosophy behind combining the Excel data into big Instrument documents is to maximize performance.  Rather than try to join a large group of mongo documents every time a query is made, this app looks for the data on the instrument and then filters the data  down for the current user (i.e. showing only prices for the country they've selected and standalong srevices for the role they've selected).  A prototpye fo this app attempted to combine the documents in real time and the request time for an instrument was about 5000ms.  This app can usualy return a results in 600ms.


### Emails

For local development, you can view the email template on your dev machine.  It is available at `/dev/emails/default`.


## Infrastructure & Related Services

This app leverages a variery of different services.

* Azure App Service: runs the Rails app.
* Azure AD: used for authentication.  The app requires EasyAuth otherwise the page won't load.
* MS Graph: sends emails.  When setting up MS Graph, be suer to add the `User.Read` and `Mail.Send` permissions.


## Required Config Variables

The main config variables point to the two databases for the app, `EXPORTED_DATA_DB_URL` and `SERVICE_HUB_DB_URL`.

You will need read acccess for the database containing exported spreadsheet data and read-write access for the database that stores the instruments.

Here's an example of what configur variables are used in production.

![Image of config](/documentation_images/config.png)


ALso, on the configuration panel, in General Settings, be sure to set "Always On" to true.


## Logging

This URL contains links to various logs used by the app: [https://gsss-servicehub.scm.azurewebsites.net/api/logs/docker](https://gsss-servicehub.scm.azurewebsites.net/api/logs/docker).

Some are for the container, others for deployment.

To view application logs, you will need to SSH into the container. In Azure, from the overview page, find "Development Tools" on the left-side toolbar and scroll down to SSH.

Once the SSH tab appears, press "Go" and Azure will launch a new SSH session.

The logs are available at `site/wwwroot/log/production.log`.



## Code Base Origins
This repo was generated from the following sample: [App Service on Linux](https://docs.microsoft.com/azure/app-service/containers).


## Notes
* A good instrument model to use as an example is `QSTUDIO7PRO`.
* Rails models for the exported spreadsheets list only the attributes being used but most collections have many more attributes.
* For auth info of current logged in user, head to [https://servicehub.gss.tf/.auth/me](https://servicehub.gss.tf/.auth/me).
* Good article of MS Easy Auth: [https://cgillum.tech/2016/03/07/app-service-token-store/](https://cgillum.tech/2016/03/07/app-service-token-store/).
