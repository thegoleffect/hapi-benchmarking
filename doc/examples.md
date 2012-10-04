    $ flod bench --all
    
    $ flod bench --server=hapi --test=helloworld 
    
    $ flod bench --remote=localhost:8000

    $ flod compare hapi@0.5.3 hapi@0.8.0

This runs the default `--test=helloworld` benchmarks using the two versions of hapi, then compares the results.