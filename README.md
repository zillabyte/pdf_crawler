# Getting Started with Zillabyte Apps

Zillabyte Apps are chunks of code that can scalably analyze almost any type of data.  You develop & test the app locally and then push to the Cloud when you are ready to scale. 

Apps are fundamentally comprised of inputs (`sources`), outputs (`sinks`), and zero or more in-between `operations`.  This style of programming is known as the [Pipe Programming Paradigm](http://blog.zillabyte.com/2014/05/14/the-pipe-programming-paradigm/) and it allows Zillabyte to scale your App in the cloud.

To learn more about Zillabyte Apps, please take a few moments and visit [docs.zillabyte.com](http://docs.zillabyte.com/)

## Step 1: Understand your Data Options

`Sources` are how you get data into your App.  

#### Source from Data Inside Zillabyte 

You can store your datasets inside Zillabyte.  In this regard, Zillabyte acts like a large database, ready to feed your App.  Consider the following: 

```ruby
require "zillabyte"

# Create an app
app = Zillabyte.app("hello_world")

# Source from the 'web_pages' dataset
stream = app.source("web_pages")

# ...
```

The above [example](http://docs.zillabyte.com/quickstart/hello_world/) will source data from the 'web_pages' dataset.  This particular dataset happens to be an [Open Dataset](http://zillabyte.com/data) and is open to all users.  

You are of course free to create private datasets that will not be accessible to the public.  To do so, use the `zillabyte data` commands. 

```bash
$ zillabyte data --help
```

 
#### Other Source Options

You are free to source from other datasets outside of Zillabyte.  To do so, please see our documentation on [docs.zillabyte.com](http://docs.zillabyte.com).


## Step 2: Build & Test your App

Once your app is built, you will want to test it locally.  The `zillabyte test` is intended to help you identify bugs before submitting to the cloud.  `zillabyte test` simulates the cloud environment on your local machine.  In your App's directory, run the following:

```bash
$ # in your app's directory
$ zillabyte test

inferring your app details...
            app name: hello_world
        app language: ruby
====================  operation #0
                name: source_1
                type: source
#... 
```


## Step 3: Submit your App to the Zillabyte Cloud 

Once you are confident in your code, you can push to the cloud and run at scale.  If you wish to push the entire directory, run the following: 

```bash
$ # in your app's directory
$ zillabyte push
packaging directory... done
uploading 31744 bytes... 
#...
```

The `zillabyte push` command may take a few minutes to complete.  During this time, you will see log output coming from the cloud servers.  You will notice your operations are being parallelized automatically.  For example, if you had an operation named `each_1`, you will see it parallelized into `each_1.1`, `each_1.2`, `each_1.3`, and so forth.  


## Step 4: Examine the Your App's Logs

The `zillabyte push` will stop streaming logs once the push sequence is complete.  If you wish to examine your app's logs further, run the `zillabyte logs` command

```bash
$ zillabyte logs

Retrieving logs for flow #hello_world...please wait...
2014-07-01T05:02:40.923+00:00 flow_1210[app] - [STARTUP] new app created.
2014-07-01T05:02:42.563+00:00 flow_1210[app] - [STARTUP] registering app.
2014-07-01T05:02:46.083+00:00 flow_1210[app] - [STARTUP] Beginning app deployment
2014-07-01T05:02:48.915+00:00 flow_1210[flow] - [STARTUP] Pulling the code from our servers...
2014-07-01T05:02:48.949+00:00 flow_1210[app] - [STARTUP] Initializing the app's environment...this might take a while.
2014-07-01T05:03:06.775+00:00 flow_1210[flow] - [STARTUP] Performing the initial setup...
```

The logs will stream indefinitely.  To terminate, hit `ctrl+c`.

## Step 5: Optionally Kill & Resubmit your App 

If you notice a problem with your app, you can make the code change and `zillabyte push` right away.  Only one instance of your app can be active at a time, so Zillabyte will automatically terminate your existing app before proceeding. 

If you wish to kill your app without re-pushing, simple run the `kill` command. 

```bash
$ # in your app's directory
$ zillabyte apps:kill
```

## Step 6: Download Results 

When your app is done processing, you will most likely have data to download from the cloud.  This can be accomplished with the `zillabyte data:pull` command.  For example: 

```bash
# list my datasets
$ zillabyte data
+------+---------------------+
| id   | name                |
+------+---------------------+
| 1516 | hello_worlds        |
+------+---------------------+
```

```bash
# download the entire dataset to a local file
$ zillabyte data:pull hello_worlds my_local_file
```

