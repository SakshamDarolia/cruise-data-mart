# cruise-data-mart

This is a **small scale Data Mart** which is essentially a part of Analytical Database, also known as OLAP (Online Analytical Processing) schema database. A Data Mart is a subset of a data warehouse focused on a particular line of business, department, or subject area. It is a smaller, more focused repository of data that is derived from the larger, centralized data warehouse.

This Data Mart is created based on the following columns (from cruise-data.csv)
1. Cruise_Number
2. Start_Datetime
3. End_Datetime
4. Ship_Name
5. Launch_Datetime
6. Tour_Datetime
7. Tour_Name
8. Tour_Description
9. Duration
10. Price

A Data Mart consists of a FACT Table and dimensions, which are connected to FACT Table.

**FACT Table:**
A fact table in a data mart contains numerical data (facts) representing business metrics like sales or quantities. It's linked to dimension tables, which provide context and descriptive attributes about the facts, such as product details or customer information.

**Dimensions:**
Dimensions are categorical and hierarchical, offering a structured view of the data. They help in organizing, categorizing, and providing meaning to the data stored in a data mart.

Together, fact tables and dimensions form the core structure of a data mart, enabling efficient analysis and reporting for specific business functions.

A high level idea for creating Data Mart is as follows:
1. Decide on the architecture of Data Mart, dividing into FACT Table and dimensions.
2. Identify Data source.
3. Create a Staging Table, containing all the columns in source data with reference ID columns from all dimensions in Data Mart.
4. Import the data into Staging Table.
5. Populate all the dimensions from Staging Table.
6. Update ID reference columns (for dimensions) in Staging Table
7. Populate all columns in FACT Table using Staging Table
