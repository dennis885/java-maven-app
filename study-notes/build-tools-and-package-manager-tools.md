## 4 - Build Tools and Package Manager Tools

### What is a artifact?

An artifact is a file that is produced by a build process.
It contains the binary or source code required to deploy an application.
For example a jar file is an artifact.
Java can produce a jar file or a war file.

#### What is inside a jar file?

A jar file is a zip file that contains a manifest file and the classes and resources of the application.
The manifest file contains information about the application like the main class and the dependencies.
For example (Java)maven uses the pom.xml as it manifest file.
Node uses the package.json as it manifest file.

### What is an artifact repository and why do we need it?

An artifact repository stores artifacts.
Nexus for example is a popular repository. It stores the built artifacts and dependencies.
You can also push for example docker images to an artifactory as Nexus.

#### Why Docker

It makes the process universal. You can run the same docker image on any machine. And you have less types of artifacts
to
manage. More practical to work with, as you can use the same docker image for development, testing and production.







