## Project Overview
The "Cleaning Data in SQL Queries" project focuses on cleaning and standardizing a dataset from the Nashville housing market. The dataset, NashvilleHousing, contains various information about property sales. The project aims to ensure data quality and consistency by performing several data cleaning tasks. These tasks include standardizing date formats, populating missing data, breaking out addresses into individual components, updating categorical values, removing duplicates, and deleting unused columns.

## Key Steps and SQL Techniques Used
1. Standardizing Date Format:

- Convert and standardize the SaleDate field to a date format.

- Ensure the date conversion is applied correctly, using an additional column if necessary.

2. Populating Missing Property Address Data:

- Identify and fill in missing property addresses using available data by joining on ParcelID.

3. Breaking Out Address into Individual Columns:

- Split the PropertyAddress into Address and City.
- Similarly, split the OwnerAddress into Address, City, and State.

4. Updating Categorical Values:

- Standardize the values in the SoldAsVacant field by converting 'Y' and 'N' to 'Yes' and 'No'.

5. Removing Duplicates:

- Identify and remove duplicate records based on a set of key columns using a Common Table Expression (CTE).

6. Deleting Unused Columns:

- Remove columns that are no longer needed after the data cleaning process.

## Conclusion

The "Cleaning Data in SQL Queries" project demonstrates how to enhance the quality and usability of a dataset through various SQL data cleaning techniques. By standardizing date formats, populating missing values, breaking out addresses into individual components, updating categorical values, removing duplicates, and dropping unused columns, the project ensures that the Nashville housing dataset is well-prepared for further analysis and reporting. This process is essential for maintaining data integrity and accuracy in any data-driven project.
