# Dockerfile reference

```
FROM registry.redhat.io/ubi8/ubi
ADD myecho /usr/local/bin
ENTRYPOINT "/usr/local/bin/myecho"
```

## Usage

```
$ docker build .
```

The build is run by the Docker daemon, not by the CLI. The first thing a build process does is send the entire context (recursively) to the daemon. In most cases, it’s best to start with an empty directory as context and keep your Dockerfile in that directory. Add only the files needed for building the Dockerfile.

To use a file in the build context, the `Dockerfile` refers to the file specified in an instruction, for example, a `COPY` instruction. To increase the build’s performance, exclude files and directories by adding a `.dockerignore` file to the context directory. For information about how to [create a `.dockerignore` file](https://docs.docker.com/engine/reference/builder/#dockerignore-file) see the documentation on this page.

Traditionally, the `Dockerfile` is called `Dockerfile` and located in the root of the context. You use the `-f` flag with `docker build` to point to a Dockerfile anywhere in your file system.

```
$ docker build -f /path/to/a/Dockerfile .
```

You can specify a repository and tag at which to save the new image if the build succeeds:

```
$ docker build -t shykes/myapp .
```

To tag the image into multiple repositories after the build, add multiple `-t` parameters when you run the `build` command:

```
$ docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest .
```

Before the Docker daemon runs the instructions in the `Dockerfile`, it performs a preliminary validation of the `Dockerfile` and returns an error if the syntax is incorrect:

```
$ docker build -t test/myapp .

Sending build context to Docker daemon 2.048 kB
Error response from daemon: Unknown instruction: RUNCMD
```

## BuildKit

Starting with version 18.09, Docker supports a new backend for executing your builds that is provided by the [moby/buildkit](https://github.com/moby/buildkit) project. The BuildKit backend provides many benefits compared to the old implementation. For example, BuildKit can:

- Detect and skip executing unused build stages
- Parallelize building independent build stages
- Incrementally transfer only the changed files in your build context between builds
- Detect and skip transferring unused files in your build context
- Use external Dockerfile implementations with many new features
- Avoid side-effects with rest of the API (intermediate images and containers)
- Prioritize your build cache for automatic pruning

To use the BuildKit backend, you need to set an environment variable `DOCKER_BUILDKIT=1` on the CLI before invoking `docker build`.

To learn about the experimental Dockerfile syntax available to BuildKit-based builds [refer to the documentation in the BuildKit repository](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md).