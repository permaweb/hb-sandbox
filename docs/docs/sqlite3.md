# **Using SQLite3 with Hyperbeam**

This guide provides the steps to integrate SQLite3 into your Hyperbeam environment, compile the necessary WASM file, and create a test case for SQLite3 functionality.

## **1. Download the SQLite3 Libraries**

First, download the SQLite3 libraries required for this setup:

- [Download SQLite3 Libs](./assets/modules/sqlite3_libs_hyperbeam.zip)

## **2. Extract the ZIP and Add the Libs Folder**

Once the ZIP file is downloaded, extract it, and place the `libs` folder inside the `ao-process` directory.

```bash
unzip sqlite3_libs_hyperbeam.zip
mv libs ./ao-process/
```

## **3. Rerun the `compile_ao-process.sh` Command**

Now that the SQLite3 libraries are in place, you need to rerun the `compile_ao-process.sh` command to regenerate the `process.wasm` file with SQLite3 support.

```bash
./compile_ao-process.sh
```

This will compile the `ao-process` source code and include the SQLite3 functionality.

## **4. Rename the `process.wasm` to `sqlite.wasm`**

After the compilation is complete, rename the generated `process.wasm` file to `sqlite.wasm`:

```bash
mv ./process.wasm ./sqlite.wasm
```

## **5. Copy the `sqlite.wasm` to the Hyperbeam `./test/custom/` Folder**

Next, copy the `sqlite.wasm` file to the `./test/custom/` folder inside the Hyperbeam repository:

```bash
cp ./sqlite.wasm <HYPERBEAM_REPO>/test/custom/
```

Ensure that the `sqlite.wasm` file is correctly placed in the `custom` folder.

## **6. Add a Test Case for SQLite in `hb_beamr_test.erl`**

Now, you need to add a test case for SQLite functionality inside the `hb_beamr_test.erl` file. You can modify or add a test function like the following:

```erlang
sql_test() ->
    WasmFile = "test/custom/sqlite.wasm",
    WasmBinary = setup_env(WasmFile),
    ?event("Running aos64_performance_test"),
    {ok, Port, _Imports, _Exports} = hb_beamr:start(WasmBinary),
    Env = gen_test_env(),
    Msg = gen_test_aos_msg(
        "local json = require('json'); " ++
        "local sqlite = require('lsqlite3'); " ++
        "local db = sqlite.open(':memory:'); " ++
        "db:exec('CREATE TABLE numbers(num)'); " ++
        "for i=1,2 do " ++
        "    db:exec('INSERT INTO numbers VALUES ('..i..')'); " ++
        "end; " ++
        "t = {}; " ++
        "for a in db:nrows('select * from numbers') do table.insert(t, a) end; " ++
        "db:close(); " ++
        "return json.encode(t);"
    ),

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
            ?assertMatch(<<"[{\"num\":1},{\"num\":2}]">>, Response);
        {error, Reason} ->
            ?event({"Unexpected response", Reason}),
            ?assert(false)  % Fail the test explicitly
    end,

    %% Stop the WASM
    hb_beamr:stop(Port),
    ?event("aos64_sql_test passed").
```

In this example, the test runs a simple SQLite query using an in-memory database, inserts values, and retrieves the results. The test checks that the values returned by the query match the expected result.

## **Running the Test**

Once the test case is added to `hb_beamr_test.erl`, you can run the test with the following command:

```bash
HB_DEBUG=1 rebar3 shell --eval "eunit:test(hb_beamr_test, [verbose])."
```

This command will start the Rebar3 shell, execute the test, and provide verbose output to help you troubleshoot any issues.

---

By following these steps, you will have successfully integrated SQLite3 into your Hyperbeam project, added a test case for SQLite functionality, and verified the behavior through a test.
