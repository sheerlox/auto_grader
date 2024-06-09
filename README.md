# AutoGrader

[![Documentation](https://img.shields.io/badge/ghpages-docs-lightgreen.svg)](https://sherlox.io/auto_grader/AutoGrader.html)

All the text below this line was written as a project plan before beginning it.

Please refer to the [documentation](https://sherlox.io/auto_grader/AutoGrader.html)
for up-to-date information.

## Abstract

I'm working on this project because I need to grade ~ 250 student projects
(3 different coding assignments, 1 on Git and 2 on Java).

My timeline is very tight, because I need to turn in the grades ASAP, but also
because I got a lot going on with @Talent-Ideal.

Because of this, and as it's my first time diving into Elixir's processes and
behaviors, this project will probably make some developers scream. My apologies
for this. But it's a good starting point, and I believe that in the future,
adding a DSL and enough utilities (e.g. to work with Git, run Java tests,
etc ...), this project can become something very interesting, leveraging the
core features of the BEAM VM and Elixir language.

## Running

```bash
mix run --no-halt
```

## Objectives

This program must be able to run a test suite for many (potentially hundreds)
of student submissions.

Submissions might be simple Git projects, Java projects with JUnit tests to
run, etc ...

The program should make use of all available CPU cores in order to grade
submissions as fast as possible.

A test unit crashing must also just be reported as having errored, and not
crash the whole test suite / program.

The project should contain basic test helpers (e.g. assert that a given
function is called inside a specific JUnit test in a given file, or inspect
the Git commit history, etc ...)

It should be easy to add a new test suite / unit.

## Reusability

In its first version, the project will be developed to grade a specific
student evaluation.

It must however be made in a way that adapting it for another evaluation
would be simple.

In the end, this project might be rewritten as a dependency application which
would expose basic primitives to reach the ojectives above. But since this is
a draft project for now, these primitives are yet to be discovered.

Ultimately, running this project inside a container might be a good idea, to
avoid bad student jokes (e.g. system commands deleting dotfiles or what not).

## Architecture/Design

This is my first time getting a shot at manual process management (GenServer,
Supervisor, Task, etc ...).

Here's a first draft of this project's architecture/design:

Main process:
- lists all student's submissions from a directory specified
in config
- spawns a GenServer/Task/idk? for each submission (`SubmissionRunner`)
- aggregates the results from each `SubmissionRunner` and returns a list of
`%{name: "", score: ""}`

`SubmissionRunner` process:
  - checks for preliminary requirements (is a Git project, contains xyz files,
etc ..)
  - determines the name of the student from the Git
history
  - spawns a process for each test unit (`TestUnitRunner`) in
the test suite
  - aggregates the results from every test unit process

## Test units

I guess test units would be modules that would implement a behavior with a
`run` callback and must return either `:pass`, `:fail` or `{:error, error}`.

This way it is very easy to add new test units to be run on every submission by
simply adding a new file and appending the module in a list in the config.

## TODO

- [X] add coefficient to test units
- [X] add bonus test units
- [ ] force system processes to exit when setup/test unit terminates (see https://hexdocs.pm/elixir/System.html#cmd/3)
