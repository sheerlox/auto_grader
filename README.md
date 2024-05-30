# AutoGrader

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
