/*
Create Database and Schemas

=========================================================================

Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it will be dropped and recreated. Additionally, the script sets up three schemas
	within the database: 'bronze', 'silver', 'gold'.


WARNING:
	Running this script will drop the entire 'DataWarehouse' database if it exists.
	All data in the database will be permenently deleted. Proceed with caution
	and ensure you have proper backups before running these script.
*/


-- STEP 1: Run this first in the 'postgres' database or any existing database

-- Drop the database if it exists
DROP DATABASE IF EXISTS "DataWarehouse";

-- Create a new database
CREATE DATABASE "DataWarehouse";


/*
=============================================================================
   STOP HERE — Switch to the new 'DataWarehouse' database manually:
   In pgAdmin: Right-click on 'DataWarehouse' > Query Tool
=============================================================================
*/


-- STEP 2: Now run the following in the 'DataWarehouse' database

-- Create the schemas if they don't already exist
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Optional: Verify that schemas are created
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('bronze', 'silver', 'gold');
