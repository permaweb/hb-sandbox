# **Hyperbeam Repository Setup**

This guide provides step-by-step instructions for setting up and testing Hyperbeam.

## **1. Clone the Hyperbeam Repository**

First, clone the `permaweb/Hyperbeam` repository from GitHub:

```bash
git clone https://github.com/permaweb/HyperBEAM
```

Navigate to the project directory:

```bash
cd HyperBEAM
```

## **2. Compile the Code with Rebar3**

To compile the Hyperbeam code, you’ll need to use Rebar3. Run the following command to compile the project:

```bash
rebar3 compile
```

This will compile the necessary code to get Hyperbeam up and running.

## **3. Run Hyperbeam with Shell**

Once the code is compiled, you can start the Hyperbeam shell with Rebar3:

```bash
rebar3 shell
```

This command will start an interactive Erlang shell where you can interact with Hyperbeam.

## **4. Test Hyperbeam with EUnit**

To run the unit tests for Hyperbeam, use the following Rebar3 command:

```bash
rebar3 eunit
```

This will execute the EUnit tests and provide the results in your terminal.

## **5. Running a Specific Module Test**

To run tests for a specific module, use the following command:

```bash
rebar3 eunit --module hb_converge
```

This will run the tests for the `hb_converge` module.

## **6. Running a Specific Test in a Module**

To run a specific test within a module, use the `rebar3 shell` command with `eunit:test`. For example, to run the `path_test` in the `hb_converge` module:

```bash
rebar3 shell --eval "eunit:test(hb_converge, [{tests, [path_test]}])"
```

This command will execute the `path_test` within the `hb_converge` module.
