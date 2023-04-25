#### graalvm builder - simplify graalvm integration for spring boot projects. 
##### why did I do that?
- graalvm native-image is simply a revolution to java applications, makes a simple and smaller binary, instead of jar. 
- the resulting docker image is less than 20% in size the one with JVM, and starts about 80-95% faster. on the other hand - the executable is platform specific.
- despite all the pros, compiling a spring boot app with graalvm is rather intimidating, and not very beginner-friendly. </br>
the aot process requires knowledge of reflection, JNI, and more - otherwise, it won't work. 
- working with graalvm with windows was a pain, so I used docker to make it easier.
- lately, the native maven plugin for graalvm integration has been doing a good job, and it looks like it's ready for production deployment.
- for example, when bringing up a k8s cluster, imagine a daemonset which deploys a pod in all nodes in lest then 1 second. 
#### why I didn't use the buildpack with the "buildImage" goal?
- both maven and gradle, give you an option out of the box to create a ready-to-use docker image with your app - the "buildImage" goal.
- unfortunately they use the terrible distroless image, which may sound safer and has less attack surface, it's just terrible to use since it doesn't have a terminal to debug. 
- that's why I chose using alpine, with added glibc toolchain for running the compiled application.(for semi-static compilation, the usually-preferred way. see the [docs](https://www.graalvm.org/latest/reference-manual/native-image/guides/build-static-executables/) for reference)
#### what does this repo do?
- using the community docker images of graalvm, it's just a set of dockerfiles and docker-compose.yaml files for compiling and creating an easy to use docker images, including terminal.

#### base-images:
- base-musl - a base image using musl toolchain, for compiling static images. can be used with distroless or scratch containers.
- base-native-image - a base image with native-image pre-installed, usefull for closed environments.

#### requirements: 
- a spring boot 3 app, using java 17, including a maven wrapper ready for use.
- you can use the example app here, or your own.

#### to run: 
- choose your compilation type - dynamic, static, or semi-static, and open a terminal in the right folder.
- use the relevant args for your env.
- if needed, create the necessary base image with `docker build` command.
- run docker compose up.(for jvm mode - just use `docker run` and supply the relevant arg)
- for semi-static mode, include the build arg `-H:+StaticExecutableWithDynamicLibC` in your pom.xml file. 
- for static mode, include the build args `--static --libc=musl` in your pom.xml.

#### semi-static-mode:
- the dockerfile for cached m2, is useful for consecutive builds, to avoid excessive file transfers and redundant downloads, so I used the compilation command in the entrypoint - so I can use volumes like my local .m2 repo to run faster. </br> excessive file transfers is not very good with docker, and can decrease performance and cause issues.
- the multistage dockerfile is using frolvlad/alpine-glibc to run the app, providing the necessary glibc toolchain and terminal, while using the small alpine base image

#### static-mode:
- using the base image with musl for static compilation, and a simple alpine for running the app.

#### note:
- I used my example [code](https://github.com/benayat/spring-boot-stomp-native) repo for this tutorial, which is a simple spring boot 3 app with stomp websocket. you can use yours, but change the build args first. 