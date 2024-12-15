# **Running Tests with Your Custom WASM**

This guide walks you through the steps to create a WASM file, integrate it into the Hyperbeam repository, modify tests, and run them.

## **1. Follow the Steps from the [WASM Compiler Setup](wasm_compiler_setup.md) to Create a WASM**

Follow the instructions in the [WASM Compiler Setup](wasm_compiler_setup.md) to clone the `hb-sandbox` repository, generate a Docker image, and compile the `ao-process` source code into a WASM file. Once you have the WASM file, you will use it in the next steps.

## **2. Copy the WASM File to the Hyperbeam Repository**

After generating the WASM file, copy it to the `test` folder inside the Hyperbeam repository. You should place the file in the `./test` directory of the Hyperbeam repository:

```bash
cp /path/to/generated/wasm/file ./test/custom/process.wasm
```

Ensure the file is accessible within the repository structure.

## **3. Edit the `hb_beamr_test.erl` to Point to Your New WASM**

In the `./src/hb_beamr_test.erl` file, locate the line:

```erlang
-define(WASM_CORE, "test/interp/process.wasm").
```

Update this line to point to your newly copied WASM file. Ensure the path correctly reflects the location of the file inside the `test` folder (`test/custom/process.wasm`).

## **4. Modify or Add Tests in `hb_beamr_test.erl`**

You can modify existing tests or add new ones inside the `./src/hb_beamr_test.erl` file. For example, you can modify the `eval_test` function to use a different expression and assert that the result matches the expected value.

Here is an example modification of the `eval_test`:

```erlang
% Test the `handle` function for correctness
eval_test() ->
    WasmFile = ?WASM_CORE,
    WasmBinary = setup_env(WasmFile),
    ?event("Running aos64_handle_test"),
    {ok, Port, _Imports, _Exports} = hb_beamr:start(WasmBinary),
    Env = gen_test_env(),
    Msg = gen_test_aos_msg("return 1+5"), % <--- Update Here

    %% Write data to WASM memory
    {ok, EnvPtr} = hb_beamr_io:write_string(Port, Env),
    {ok, MsgPtr} = hb_beamr_io:write_string(Port, Msg),

    %% Call the "handle" function in the WASM
    {ok, [ResultPtr]} = hb_beamr:call(Port, "handle", [MsgPtr, EnvPtr]),

    %% Read and parse the result
    {ok, ResponseBin} = hb_beamr_io:read_string(Port, ResultPtr),
    case parse_wasm_response(ResponseBin) of
        {ok, Response} ->
            ?event(io_lib:format("Response: ~p", [Response])),
            ?assertMatch(<<"6">>, Response);   % <--- Update Here
        {error, Reason} ->
            ?event({"Unexpected response", Reason}),
            ?assert(false)  % Fail the test explicitly
    end,

    %% Stop the WASM
    hb_beamr:stop(Port),
    ?event("aos64_handle_test passed").
```

In this example, the expression `return 1+5` is tested, and the result should be `"6"`. You can change the expression to any other valid WASM code, and adjust the expected result accordingly.

## **5. Run the Test**

Once the tests are updated, you can run the tests using the following command:

```bash
HB_DEBUG=1 rebar3 shell --eval "eunit:test(hb_beamr_test, [verbose])."
```

This command will start the Rebar3 shell, run the tests, and display verbose output, helping you to troubleshoot any issues that arise during testing.

---

By following these steps, you will be able to integrate your custom WASM into the Hyperbeam repository, modify and add tests, and run them to verify the behavior of your system.
