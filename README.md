# Real Time Wine Quality Model
A full, production-ready system which is designed to make predictions on the
expected quality of the wine based upon fluctuating IoT readings.


## Introduction

### Welcome!
Thank you for taking the time to explore this repository! This project was 
developed to help new ML engineers wrap their head around some of the 
undertaught parts of computer science: developing a fully-functioning solution
for your clients or employer. It covers less of the concepts around Data Science,
such as model selection and feature engineering, and instead focuses on how you
can deploy these models into a value-generating environment.

This system has been designed around an imaginary scenario. I've deliberately 
picked a trivial yet realistic example to help you understand why I've made the
decisions that I did. The focus of this project is not 

### Business Context
You've been approached by a winemaker who is looking at employing machine 
learning in her business to help drive a more data-driven decision making 
process around his cask pricing. This winemaker has IoT sensors connected to
her barrels that is constantly feeding information into her sensor database.
She knows that this data being collected, fundamentally, captures the final 
quality of the wine that is produced. She isn't quite sure of the specifc values
that makes a good wine and as such she thinks that machine learning might be 
able to determine what makes a good wine.

Currently, she has to taste every barrel of wine that's produced to grade it on
a score of 1-10. This grade ultimately effects the price that she can sell the
wine at. These tasting sessions take up 10 man-hours a week from her employees
and are prone to subjective palettes rather than objective ratings. She'd like
to, ultimatley, completely remove the need to conduct tastings to price her 
wines.

### Technical Context
The IoT data is collected in a real-time fashion and is constantly updating 
the current reading values in her DynamoDB NoSQL database. You can expect that
the readings will change on average every 10 seconds.

The interactions between features that make up a good wine are fairly constant,
and as such an ad-hoc and manual approach to updating the trained model is 
sufficient.


## Requirements
In order to get this solution working you will require the following installed
into your system:

- Terraform (>= 0.12)
- Miniconda or Anaconda package manager
- AWS Account with credentials


## Installation
You can install the source code through the `Makefile` utilities. To setup the
project run:

```
make init
```

This will install any necessary dependencies into your environment. You will
need to build the source code and push it into your AWS environemt before you 
can construct the infrastructure. To do this, run the commands:

```
make build
make push
```

Once this is complete, you can standup a copy of the infrastructure using the 
command:

```
make infrastructure
```

This will create your own copy of the environment within your default AWS
environment.

This infrastructure won't have any data pushed into it: you'll have to do this
yourself. The command to do this is:

```
make database
```

Now you have everything to get your solution working! You can manually peturb
the values in your database to see the reflected effects, or you can run another
utility which simulates the real-time IoT data:

```
make simulation
```

Now you'll be changing the values of the wine data at a rate of approximately 
every 10 seconds. 

Once you're done exploring the source code you can destroy all of the resources
created using the command:

```
make destroy
```