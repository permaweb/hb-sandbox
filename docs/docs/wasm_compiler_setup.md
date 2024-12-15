# **WASM Compiler Setup**

This section provides instructions for building the WASM compiler and compiling your source code into a WASM file for use with HyperBeam.

## **1. Checkout the `hb-sandbox` Repository**

First, you need to clone the `hb-sandbox` repository, which contains the necessary scripts and tools for building the WASM compiler.

```bash
git clone https://github.com/permaweb/hb-sandbox
```

Navigate to the `hb-sandbox` directory:

```bash
cd hb-sandbox
```

## **2. Generate the Docker Image**

The next step is to generate a Docker image that will be used to compile your source files into a WASM. To do this, run the `build_wasm_compiler.sh` script:

```bash
./build_wasm_compiler.sh
```

This script will build a Docker image that includes all the necessary dependencies for compiling source files into WASM.

## **3. Compile the `ao-process` Source Code**

Once the Docker image is built, you can use it to compile the `ao-process` source code into a WASM file that can be used in HyperBeam.

Run the `compile_ao-process.sh` script to compile the source code:

```bash
./compile_ao-process.sh
```

This will use the newly generated Docker image to compile the `ao-process` source code into a WASM file located at `./process.wasm`.

## **Final Output**

After running the `compile_ao-process.sh` script, you will have a WASM file ready to be used within the HyperBeam environment.
