# ![🐛 Smittesporing - Covid-19 Contact Tracing](https://user-images.githubusercontent.com/3652587/76966051-44f38700-691d-11ea-9e6f-029972c943f9.jpg)

An open-source project to provide government health organisations with the plug-and-use tools to monitor Covid-19 spread by help of a mobile app (Android & iOS) that traces and stores the citizen's movements securely on the device. The citizen submits these securely to the government registry only when the user reasonably suspects to carry symptoms or to have been in contact with confirmed cases. Thanks to the more accurate data, health workers can much more easily trace contacts and identify patterns.

Health workers can
- Analyse outbreak areas and identify sources of contagion 
- Trace corona symptoms and possible contacts in real-time
- Forecast need of treatment for covid-19 in the coming days

End users can
- Share their current symptoms and movements with the government, help detect source of infections
- Receive alert if user has been in a high-endemic location
- Overview of relevant/personalised rules and guideliens given your case history

## ❓ Why?

Countries facing Covid-19 outbreak *urgently* need radically better tools for contact tracing, to identify sources and limit further spread. On Sunday 15 March, Norway's leading UX & tech agency therefore launched this open source effort, after consideration of how we could best help the situation the world is facing. Whilst we started with deployment in Norway as the main case, we quickly realised that this project may be even more important in other countries.

We have no commercial interest here, and we don't have an existing product to peddle.

## 🗺️ Is this in use by any health organisations yet?

We just launched, however we are already in touch with several entitites within the Norwegian government - both in health authorities and international development. Yet understandably they are quite swamped at the moment.

A few governments have already bootstrapped similar apps for contact tracing (Singapore, Philippines, China, Israel) - however this project aims to be easily deployed in any country, yet whilst ensuring security and privacy concerns.

## 🤔 Why don't you use X, Y or Z?
We are open to all suggestions, yet have a strong preference for limiting both scope and use of third-party frameworks and libraries now, so we can ship quickly. We can be ready to launch the apps from April.

We chose for instance to focus on native location tracking as this is the tech that provides the most reliable data with shortest time to market. Tracing of contacts via bluetooth (whilst also valuable) is complex to get working, and includes working around privacy measures put in place in iOS with third-party libraries.

There are many benefits from limiting use of third-party frameworks and libraries. With native mobile apps we ensure not only good location data but as importantly better privacy and security with less risk of data bleed.

## 🔐 Security and privacy

We create the frontend following best practice with regards to privacy and security, including SSL pinning, strong encryption using secure enclave.

The backend for this project is (currently) out of scope, yet we have thoughts and suggestions about the design/architecture ad data visualisation tools. The data is anonomyised when shared with the backend. We believe that this data should nevertheless be treated as health data, and should only be available by trusted health authorities.

## 🗂 Resources

#### Pitch and vision

[![Image](https://user-images.githubusercontent.com/3652587/77009616-1d71de00-6960-11ea-8ca4-35f2b549c297.jpg)](https://docs.google.com/presentation/d/1HzRt4ows4wgMnpFP22DQdgAjMGJ5MQl10E8UzW5PROQ/edit?usp=sharing)

Norwegian version: [https://docs.google.com/presentation/d/1HzRt4ows4wgMnpFP22DQdgAjMGJ5MQl10E8UzW5PROQ/edit?usp=sharing](https://docs.google.com/presentation/d/1HzRt4ows4wgMnpFP22DQdgAjMGJ5MQl10E8UzW5PROQ/edit#slide=id.p)

English version: [https://docs.google.com/presentation/d/1gSJ7ohVBFdqynN2oO6TFzC_-__iJxMXx46B9C2vzhZY/edit?usp=sharing](https://docs.google.com/presentation/d/1gSJ7ohVBFdqynN2oO6TFzC_-__iJxMXx46B9C2vzhZY/edit?usp=sharing)

#### Design files

[![Image](https://user-images.githubusercontent.com/3652587/76911085-bee92900-68a7-11ea-93ef-93be2cab8fd6.png)https://www.figma.com/file/uhSNnqm8nNH912WQQnr0c4/Smittesporing?node-id=0%3A1](https://www.figma.com/file/uhSNnqm8nNH912WQQnr0c4/Smittesporing?node-id=0%3A1)

## 🙌 How can I help?

Glad you asked!

#### Spread the word

Do you know anyone in health authorities or health NGO that might be helpful to make this happen - reach out to them.

#### Join as project manager

We need someone who can create issues and tasks with acceptance criterias.

#### Join as designer

[Join](https://join.slack.com/t/smittesporing/shared_invite/zt-cu8u059j-uRE_2T7JJR~y_T8T0pUIrQ) our slack to talk more. We'll be happy to give you access to Figma. If you prefer Sketch, then that's fine too.

Design ideas to be explored include:
- Gamify the quarentine with streaks.

#### Join as app developer

High level we got work to do such as

- Tracking location in the background
- Storing locations
- Exporting locations
- Exporting forms

#### Join as web developer

Needs include
- Web apps to analyse and visualise the data (especially GeoJSON with time-series data).
- Setting up a public website for the project.
- See the google slides for more ideas. More tasks to be added. 

#### Join as tester 

Anyone can try the builds below 👇

Especially keen to get in touch if you are health professional to QA on the self reporting, etc.

Send your feedback on slack or on github issues.

## ✅ Tasks

We will use [issues](https://github.com/agens-no/smittesporing/issues) for tasks that needs to be done.

## 💬 Chat with us

[Join us on <img src="https://user-images.githubusercontent.com/3652587/76966259-97cd3e80-691d-11ea-9f2a-b84e3989cdd6.png" width=60/> now!](https://join.slack.com/t/smittesporing/shared_invite/zt-cu8u059j-uRE_2T7JJR~y_T8T0pUIrQ)

## ⚖️ License

Fully open source under MIT license.

## 📲 Download latest build

- [Android](https://install.appcenter.ms/orgs/agens/apps/smittesporing/distribution_groups/public)
- [iOS](https://install.appcenter.ms/orgs/agens/apps/Smittesporing-1/distribution_groups/public)
