## v0.0.3:

* Enhance : Improve the error handling when the graphite server is unable to be accessed when the reporter handler
            executes.
* Bug     : Use `Chef::Config[:file_cache_path]}` to determine the cache path rather than hard coding it.

## v0.0.2:

* Enhance : Include the `chef_handler::default` recipe from the `graphite_handler::default` recipe to ensure
            the required directory has been created.

## v0.0.1:

* Initial release.
