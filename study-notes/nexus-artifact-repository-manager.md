## 6 - Artifact Repository Manager with Nexus

Nexus does support a wide variety of artifact types like docker images, npm packages, maven packages, etc.
This means it is a good choice for a repository. It is also easy to set up and use.
The downside of Nexus is it can get messy very easy because it has so much features.
A recommendation is to use Nexus for storing docker images, composer(php) and maven packages.

Nexus also can be like a proxy for other repositories like npmjs, maven central, etc.
This has as advantage that you can use your own nexus repository as a proxy for other repositories.
When you use a package from another repository, it will be stored inside your nexus repository.
This way you can use your own nexus repository as a cache for other repositories.

Nexus also has a rest api what can be used to push and pull artifacts.
This is very useful when you want to automate the process of pushing and pulling artifacts.

It also has multi tenancy support, which means you can create multiple repositories for different users.
This is very useful when you have multiple teams that use the same nexus repository.

You can also limit access to the repositories by using roles and users.
This is very useful when you want to limit access to the repositories.

A useful feature is that you can run Nexus inside a docker container.
Another useful feature is that you can run Nexus inside a Kubernetes cluster.

### Nexus API

Examples how to use the nexus api:

- list all repos available
  ```  curl -u user:pwd -X GET 'http://{host}:8081/service/rest/v1/repositories'```
- list all components in specific repository
  ```   curl -u user:pwd -X GET 'http://{host}:8081/service/rest/v1/components?repository=<INSERT_REPO>'  ```

- list all assets for specific component
  ``` curl -u user:pwd -X GET 'http://6{host}:8081/service/rest/v1/components/<ID>'  ```
