# T&H IDO Master Build Project

Used when building a new T&H IDO master template.  It contains the primary dataset as well as references to the most recent published T&H IDO packages.

Code/Config in this project include pieces of the SDO and are part of the Happy Soup and therefore not packaged.  This allows for a "mock SDO" environment to be created as much as possible to test the Master Template build and data load process.

A primary example of what code/config would be here are External_ID fields on objects that are part of the SDO.  This enables us to test the IDO dataloading process which leverages the Q Labs Datapack standard/format.

The most important elements within in project are within the data/prod folder as that contains the initial SDO dataset, field mappings as well as forcedotcom dataloader process-config files.
``
