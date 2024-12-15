# **Prerequisites**

Before you can start setting up and running the WASM compiler and Hyperbeam repository, make sure you have the following tools installed:

## **1. Install Docker**

Docker is required to create and manage isolated environments for building and running your projects, including compiling the WASM. It provides a containerized environment where the necessary tools and dependencies for compiling the WASM are installed. You will use Docker to build the Docker image required for compiling your source code into a WASM file.

## **2. Install Erlang and Rebar3**

Erlang is a key component for building and running projects that require concurrent, distributed systems. Rebar3 is a build tool for Erlang projects.

### **Installation Instructions:**

- **Prerequisites:**

  ```bash
  sudo apt-get update
  sudo apt-get install -y libssl-dev ncurses-dev make cmake gcc g++
  ```

- **Install Erlang:**

  ```bash
  git clone https://github.com/erlang/otp.git && cd otp && git checkout maint-27 && ./configure && make -j8 && sudo make install
  ```

- **Install Rebar3:**

  ```bash
  git clone https://github.com/erlang/rebar3.git && cd rebar3 && ./bootstrap && sudo mv rebar3 /usr/local/bin/
  ```

## **3. (Optional for AOT) Install LLVM and WAMRC**

Coming Soon...
