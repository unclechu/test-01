test-01
=======

Deploy
------

1. Pull git submodules:

  ```bash
  $ git submodule update --init 
  ```
2. Copy [config.yaml.example](./config.yaml.example) to `config.yaml`:

  ```bash
  $ cp config.yaml.example config.yaml
  ```

  And set correct 'DATABASE' in `config.yaml`;
  
3. Install dependencies and build front-end:

  ```bash
  $ npm install
  ```

4. Run HTTP server:

  ```bash
  $ ./start-server.sh
  ```
