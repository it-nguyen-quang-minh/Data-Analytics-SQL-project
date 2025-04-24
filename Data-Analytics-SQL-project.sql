---Cleaning Nashville Housing Data---


/*
Cleaning Nashville Housing Data focus on cleaning and standardizing dataset from housing maket.
The project aims to ensure data quality and consistency by performing several data cleaning tasks.
These tasks include:
- standardizing date formats,
- populating missing data, 
- breaking out addresses into individual components, 
- updating categorical values, 
- removing duplicates, 
- and deleting unused columns.

Using the clauses: 
*/




-- Tạo cơ sở dữ liệu mới
CREATE DATABASE PortfolioProject;
CREATE DATABASE NashvilleHousing;
GO

-- Sử dụng cơ sở dữ liệu mới
USE NashvilleHousing;
Go


-- Import dữ liệu: sử dụng import wizard



/*

Cleaning Data in SQL Queries

*/

-- Quick review
Select *
From dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- the previous data type is DATE: YYYY-MM_DD, lets convert to DD-MM-YYYY-------CONVERT(data_type(length), expression, style)
Select SaleDate AS Original, CONVERT(nvarchar,SaleDate,105) AS Converted              -- 
From PortfolioProject.dbo.NashvilleHousing

-- update date converted in clolumn'SaleDate' in a new column named Converted()    CONVERT(data_type(length), expression, style)
Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data into the cells that is Null(with date in the other cells with the same ParcelID has the same ParcelId as the 'null one')
-- select all from  where PA is null order by parcelID increased
Select *
From NashvilleHousing.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID


-- check house Adress and its ParcelID
Select a.ParcelID, a.PropertyAddress from NashvilleHousing.dbo.NashvilleHousing a
Select b.ParcelID, b.PropertyAddress from NashvilleHousing.dbo.NashvilleHousing b


--  show 2 tempor table of PA that have the same PID joint together thats display then we can fill null value
--display a pair of a, a pair of b, and a column that be issued by ISNULL function: ISNULL if adress in a is null, replace null with b adress  
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)  -- ISNULL function: ISNULL ( check_expression , replacement_value )
From NashvilleHousing.dbo.NashvilleHousing a 
JOIN NashvilleHousing.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID               --on display ParcelID of a and b on the same line
	AND a.[UniqueID ] <> b.[UniqueID ]       -- and on uniqeID can not be the same
Where a.PropertyAddress is null              -- a is null, so b can not be

-- update if adress in a is null, replace null with b adress
Update a    --update NashvilleHousing, allies it by a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)    --set column PA = IS NULL: replace a by b if a is null
From NashvilleHousing.dbo.NashvilleHousing a    -- from 2 tempor table joined together
JOIN NashvilleHousing.dbo.NashvilleHousing b    -- they are joined by condition: the same ParcelID
	on a.ParcelID = b.ParcelID                  -- they are joined by condition: the same ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]          -- and no referencing itseft
Where a.PropertyAddress is null
---ISNULL ( check_expression , replacement_value )






--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City)

-- first check if is ther any data cell in PA is null?
Select PropertyAddress
From NashvilleHousing.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID


-- prevision
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address               -- At the PA column cut from the first letter to the one before the comma. CHARINDEX: ( expressionToFind , expressionToSearch [ , start_location ] )
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City -- At the PA column cut from the comma to all the rest of PA
From NashvilleHousing.dbo.NashvilleHousing

----SUBSTRING ( expression , start , length )---- SELECT SUBSTRING('Hello, world!', 8, 5);  -- Kết quả: 'world'
----CHARINDEX: ( expressionToFind , expressionToSearch [ , start_location ] )---- SELECT CHARINDEX('o', 'hello world', 3);    -- Kết quả: 5 (tìm kiếm bắt đầu từ vị trí thứ 3)



-- update
ALTER TABLE NashvilleHousing
ADD HouseAddress Nvarchar(255);

Update NashvilleHousing
SET HouseAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add City Nvarchar(255);

Update NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

-- check:
Select *
From NashvilleHousing.dbo.NashvilleHousing




Select OwnerAddress
From NashvilleHousing.dbo.NashvilleHousing


Select     
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)       
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)      
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing.dbo.NashvilleHousing


SELECT REPLACE(OwnerAddress,',','.')
FROM NashvilleHousing

--PARSENAME('object_name', object_piece ) ---- SELECT PARSENAME('server1.database2.dbo.table3', 3);  -- Kết quả: 'database2' 
--REPLACE(string_expression, string_pattern, string_replacement) ---- SELECT REPLACE('Xin chào, thế giới!', 'thế giới', 'bạn') AS KetQua; kq: Xin Chao, ban!  String expression may be icluded in a column
--* NOT LIKE OTHERS, PARSENAME works from the right to the left of the string Conforms to hierarchical structure for information retrieval, so do RIGHT() and REVERSE()

ALTER TABLE NashvilleHousing       --alter table Nash.. add column Nvarchar(255)
Add OwnerAddressShortened Nvarchar(255);

Update NashvilleHousing                      -- update table set this column = 
SET OwnerAddressShortened = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
Select OwnerAddressShortened from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
Select OwnerCity from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
Select OwnerState from NashvilleHousing 



Select *
From NashvilleHousing.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field (Y and Y are no boolen so we need to change it)

--show how many differant type of data in SoldAsVacant and the number of times each of them appear
Select Distinct(SoldAsVacant), Count(SoldAsVacant)     -- select distince data in column, then count data
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2                  -- arrange in order by the second column




Select SoldAsVacant                 -- Show 
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'   -- set this column = case in this = Y then Yes
	                    When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant           -- else keep the original
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------
--check for duplicate records
-- Remove Duplicates


Select *
From NashvilleHousing.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From NashvilleHousing.dbo.NashvilleHousing




-- show all house's Sale prices > $300000

Select SalePrice From NashvilleHousing Where SalePrice > 300000  -- For the first time, This line can not be run beacause data type of this column is nvarchar and can not be convert to float

    SELECT SalePrice                     -- now i need to run this lines to check if any cell has data include characters: $ , . ...
    FROM NashvilleHousing
    WHERE TRY_CONVERT(NUMERIC, SalePrice) IS NULL 
    AND SalePrice IS NOT NULL;
 
UPDATE NashvilleHousing                    -- then I run this lines to delete all the ".", repeat with "$" and ","
SET SalePrice = REPLACE(SalePrice, '.', '')
WHERE TRY_CONVERT(NUMERIC, SalePrice) IS NULL 
AND SalePrice IS NOT NULL;


ALTER TABLE NashvilleHousing        -- now run this to convert nvarchar to float 
ALTER COLUMN SalePrice FLOAT;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousing' AND COLUMN_NAME = 'SaleDate';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'NashvilleHousing';



SELECT * 
FROM NashvilleHousing
WHERE YEAR(SaleDate) = 2015;


-- count the number of the houses that saled for each city 
SELECT *
FROM NashvilleHousing

SELECT City, COUNT(*) AS NumberOfHousesSoldInThisCity   -- choose PropertySplitCity, count all the row(corespond to the number of city(each houses sold from))
FROM NashvilleHousing
GROUP BY City;
/*
GROUP BY cột1, cột2, ... in this line, NumberOfHousesSold is group by PropertySplitCity
*/


--Show city that have > 100 houses sold
SELECT City, COUNT(*) AS NumberOfHousesSold
FROM NashvilleHousing
GROUP BY City
HAVING COUNT(*) > 100;


-- Show all the houses that its price is between $300000 and $500000 and be sold in 2014
SELECT * 
FROM NashvilleHousing 
WHERE SalePrice BETWEEN 300000 AND 500000
AND YEAR(SaleDate) = 2014;

SELECT * 
FROM NashvilleHousing
WHERE SoldAsVacant = 'Yes' 
OR Acreage > 1;

-- find all the houses that has price higher than average price of all other houses
SELECT *
From NashvilleHousing
Where SalePrice > ( Select AVG(SalePrice) FROM NashvilleHousing);

SELECT 
    c.TABLE_NAME AS Tên_Bảng, 
    c.COLUMN_NAME AS Tên_Cột,
    c.DATA_TYPE AS Kiểu_Dữ_Liệu
FROM 
    INFORMATION_SCHEMA.COLUMNS c
ORDER BY 
    c.TABLE_NAME, 
    c.ORDINAL_POSITION;


-- Show all the ParcelID that have more than one sale linked belong to them , and how many time it showed
SElect ParcelID, Count(*) AS SoLanXuatHien
FROM NashvilleHousing
Group BY ParcelID
Having Count(*) >1  

--  Round the median selling price of all homes the the nearest thousand
SELECT Round(AVG(SalePrice), -3) AS Averagesaleprice 
From NashvilleHousing 
----ROUND ( numeric_expression , length [ , function ] ) ----SELECT ROUND(123.456, 2); -- Kết quả: 123.46 (làm tròn đến 2 chữ số thập phân)

-- Average land area to the second decimal rounded
SELECT ROUND(AVG(Acreage), 2) AS AverageAcreage
FROM NashvilleHousing;








--Extract the first 4 characters from the column PropertyAdress
SELECT SUBSTRING(PropertyAddress, 1, 4) AS FirstFiveCharacters
FROM NashvilleHousing;

--Extract the first 4 characters from OwenerAddress as Zipcode
SELECT Substring(OwnerAddress,1,4) as Zipcode
FROM NashvilleHousing

-- Show Change all character in OwnerSplitAddress Lower
SELECT LOWER(OwnerAddress) AS lowered_adresss
FROM NashvilleHousing

-- Show all the distinct cities in upper
SELECT DISTINCT UPPER(City) AS UniqueCitiesUpperCase
FROM NashvilleHousing;

--8 show all; create a row that  number all the following the Price sale bein decrease       
SELECT *, ROW_NUMBER() OVER (ORDER BY SalePrice DESC) AS RowNum  -- Over: combine row_number to function with ORDER BY
FROM NashvilleHousing;                                           -- AS RowNum: create a new column


--8 show all; Create a row that number all the following they are grouped in partition and  Sale date increase    
SELECT *, ROW_NUMBER() OVER (PARTITION BY City ORDER BY SaleDate) AS RowNum
FROM NashvilleHousing;


--9 ranking all the house order by price, same rank if the price is same (number row keep counting, now count rank, show rank)
SELECT *, RANK() OVER (ORDER BY SalePrice DESC) AS SalePriceRank
FROM NashvilleHousing;

SELECT *, Rank() OVER (ORDER BY SalePrice DESC) AS SalePriceRank
FROM NashvilleHousing


--9 ranking all the house order by price, same rank if the price is same ( now count number of row, count rank, show rank )
SELECT *, DENSE_RANK() OVER (ORDER BY SalePrice DESC) AS SalePriceDenseRank
FROM NashvilleHousing;


--10 find the average, min an max
SELECT AVG(SalePrice) AS AverageSalePrice, 
       MIN(SalePrice) AS MinSalePrice, 
       SUM(SalePrice) AS TotalSaleValue
FROM NashvilleHousing;

-- I find out a problem with the data in database that saleprice is 50
SELECT *
FROM NashvilleHousing
WHERE SalePrice = (SELECT MIN(SalePrice) FROM NashvilleHousing);

--Fix it
SELECT COUNT(*) AS NumberOfRows
FROM NashvilleHousing
WHERE SalePrice = 50;

UPDATE NashvilleHousing
SET SalePrice = 50000
WHERE SalePrice = 50;
------ Vấn đề ở đây là còn nhiều ô data khác có thể chứ dữ liệu = 35, 100, 2000,... vậy phải làm sao?

--11 Show how many houses sold
SELECT COUNT(*) AS VacantHousesSold
FROM NashvilleHousing
WHERE SoldAsVacant = 'Yes';


--Tính giá bán trung bình của các căn nhà trong mỗi năm. Calculate the average selling price of each year
SELECT DISTINCT YEAR(SaleDate) AS SaleYear, 
       AVG(SalePrice) OVER (PARTITION BY YEAR(SaleDate)) AS AverageSalePrice
FROM NashvilleHousing;

--15 A new Ranking Column 
SELECT *,
CASE                                                    --SELECT all, in case when this then that when this then that else that end as new column from table
  When SalePrice < 200000  then 'Rẻ'
  WHen SalePrice BETWEEN 200000 and 500000 then 'Trung bình'
  ELSE 'Cao'
END AS PriceCategory
FROM NashvilleHousing



--16 all JOIN

---> to the bottom




-- Create a new a column that its data is get from a existing column (Check all sales missed data)
ALTER TABLE NashvilleHousing
ADD Missing_Data INT; -- Adjust data type if needed

ROLLBACK TRANSACTION;
UPDATE NashvilleHousing                    -- update table, set this column = in case when that column is null then UniqueID, else null end
SET Missing_Data = CASE 
    WHEN OwnerAddress Is NULL THEN UniqueID
    ELSE NULL -- Handle other potential values in SoldAsVacant
END;


-- !!!!DELETE MAKE SURE TO BE CAREFUL AT HIGHEST LEVEL DOING THIS
-- Bắt đầu một giao dịch
BEGIN TRANSACTION;

-- Thực hiện các thay đổi (ví dụ: DELETE)
DELETE FROM NashvilleHousing
WHERE Missing_Data is NULL;       ---- This caused DATA from many column be deleted unexpectedly

-- Nếu muốn hoàn tác các thay đổi
ROLLBACK TRANSACTION;

-- Nếu muốn lưu các thay đổi
COMMIT TRANSACTION;

/*
ROLLBACK TRANSACTION;
UPDATE NashvilleHousing                    -- update table, set this column = in case when that column is null then UniqueID, else null end
SET Missing_Data = CASE 
    WHEN OwnerAddress Is NULL THEN UniqueID
    ELSE NULL -- Handle other potential values in SoldAsVacant
END;
*/




--Change SaleDate from  varchar thats DD/MM/YYYY to MM/DD/YYYY   ---CONVERT(data_type[(length)], expression [, style])

SELECT CONVERT(varchar, CAST(SaleDate AS date), 101) as SaleDate_Formatted          ---CAST(expression AS data_type[(length)]) used to change data type
FROM NashvilleHousing;
--use it is okey if SaleDate follow the format 'DD/MM/YYYY'.
SELECT CONVERT(varchar, SaleDate, 101) as SaleDate_Formatted
FROM NashvilleHousing;
--to convert to: Month, DD, YYYY
SELECT CONVERT(varchar, CONVERT(date, SaleDate, 23), 107) as SaleDate_Formatted
FROM NashvilleHousing;


-- get the Average price of houses in each city and then show the price that higher than 200000
--The With Clause
WITH CityAveragePrices AS (
    SELECT City, AVG(SalePrice) AS AvgPrice
    FROM NashvilleHousing
    GROUP BY City
)
SELECT *
FROM CityAveragePrices           -- Average Price from each city
WHERE AvgPrice > 200000;
/*
WITH temp_table_name AS (
    SELECT column1, column2, ...
    FROM table_name
    WHERE condition
)
SELECT * 
FROM temp_table_name;
*/

-- add data to table(the average)
-- 1. Thêm cột mới vào bảng NashvilleHousing
ALTER TABLE NashvilleHousing
ADD AvgPriceByCity FLOAT;  

WITH CityAveragePrices AS (
    SELECT City, AVG(SalePrice) AS AvgPrice
    FROM NashvilleHousing
    GROUP BY City
)
UPDATE NashvilleHousing
SET NashvilleHousing.AvgPriceByCity = CityAveragePrices.AvgPrice
FROM NashvilleHousing
JOIN CityAveragePrices ON NashvilleHousing.City = CityAveragePrices.City
WHERE CityAveragePrices.AvgPrice > 200000;



--- use Alias
WITH CityAveragePrices AS (
    SELECT PropertySplitCity, AVG(SalePrice) AS AvgPrice
    FROM NashvilleHousing
    GROUP BY PropertySplitCity
)
UPDATE nh
SET nh.AvgPriceByCity = cap.AvgPrice
FROM NashvilleHousing nh
JOIN CityAveragePrices cap ON nh.PropertySplitCity = cap.PropertySplitCity
WHERE cap.AvgPrice > 200000;



Select *
From dbo.NashvilleHousing

DROP TABLE IF EXISTS [NashvilleHousing]




-- 1. Tự nối (Self Join) để tìm các bất động sản có cùng LandUse
SELECT TOP 100 A.PropertyAddress, B.PropertyAddress
FROM NashvilleHousing A
JOIN NashvilleHousing B 
ON A.LandUse = B.LandUse AND A.UniqueID <> B.UniqueID;

-- 2. Inner Join để tìm các bất động sản được bán vào cùng một ngày
SELECT A.PropertyAddress, B.PropertyAddress
FROM NashvilleHousing A
JOIN NashvilleHousing B 
ON A.SaleDate = B.SaleDate AND A.UniqueID <> B.UniqueID;

-- 3. Left Join để liệt kê tất cả các bất động sản và thông tin chủ sở hữu của chúng (nếu có)
SELECT A.PropertyAddress, A.OwnerName, A.OwnerAddress
FROM NashvilleHousing A
LEFT JOIN NashvilleHousing B 
ON A.ParcelID = B.ParcelID AND A.OwnerName IS NOT NULL;

-- 4. Right Join để liệt kê tất cả chủ sở hữu và địa chỉ bất động sản của họ (nếu có)
SELECT A.OwnerName, A.OwnerAddress, B.PropertyAddress
FROM NashvilleHousing A
RIGHT JOIN NashvilleHousing B 
ON A.ParcelID = B.ParcelID;

-- 5. Full Outer Join để liệt kê tất cả bất động sản và chủ sở hữu, ngay cả khi không có sự khớp nối
SELECT A.PropertyAddress, A.OwnerName, B.OwnerAddress
FROM NashvilleHousing A
FULL OUTER JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID;

-- 6. Inner Join để tìm các bất động sản được bán với cùng SalePrice
SELECT A.PropertyAddress, B.PropertyAddress
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.SalePrice = B.SalePrice AND A.UniqueID <> B.UniqueID;

-- 7. Left Join để liệt kê tất cả các bất động sản và quận thuế của chúng (nếu có)
SELECT A.PropertyAddress, B.TaxDistrict
FROM NashvilleHousing A
LEFT JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID;

-- 8. Right Join để liệt kê tất cả các quận thuế và bất động sản nằm trong chúng (nếu có)
SELECT A.TaxDistrict, B.PropertyAddress
FROM NashvilleHousing A
RIGHT JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID;

-- 9. Inner Join để tìm các bất động sản có cùng số phòng ngủ và phòng tắm đầy đủ
SELECT A.PropertyAddress, B.PropertyAddress
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.Bedrooms = B.Bedrooms AND A.FullBath = B.FullBath AND A.UniqueID <> B.UniqueID;

-- 10. Left Join để liệt kê tất cả bất động sản và thành phố nơi chủ sở hữu sinh sống (nếu có)
SELECT A.PropertyAddress, B.OwnerCity
FROM NashvilleHousing A
LEFT JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID;

-- 11. Right Join để liệt kê tất cả các thành phố và bất động sản có chủ sở hữu sinh sống ở đó (nếu có)
SELECT A.OwnerCity, B.PropertyAddress
FROM NashvilleHousing A
RIGHT JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID;

-- 12. Inner Join để tìm các bất động sản được xây dựng trong cùng một năm và có cùng mục đích sử dụng đất
SELECT  A.YearBuilt, A.LandUse, A.PropertyAddress, B.PropertyAddress
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.YearBuilt = B.YearBuilt AND A.LandUse = B.LandUse AND A.UniqueID <> B.UniqueID;







---1 baner kích thước A4, KHOA CNTT, CHAO DON TAN SINH VIEN 



ROLLBACK TRANSACTION;

Select *
From dbo.NashvilleHousing


SELECT COUNT(*) AS 'Number of houses'
FROM NashVilleHousing 
WHERE SalePrice BETWEEN 200000 AND 300000
AND YEAR(SaleDate) = 2014
AND City = 'JOELTON'
AND Acreage BETWEEN 1 AND 2;




/*
Đoạn code SQL sau đây phân loại các giao dịch bán nhà theo thành phố, năm bán và khoảng giá, sau đó đếm số lượng giao dịch trong mỗi nhóm bằng cách sử dụng đồng thời các hàm PARTITION BY, CASE, và GROUP BY.
Trả lời cho câu hỏi: Với từng thành phố, cho biết số lượng nhà bán ra theo ba mức giá trong từng năm, được săps xếp tăng dần theo năm
*/
WITH PriceRangeCTE AS (        -- First create a Tempor table named that
    SELECT 
        *,    -- get all data to the tempor table
        CASE   
            WHEN SalePrice < 100000 THEN 'Thấp'   -- Then create new column and set its condition for that table
            WHEN SalePrice BETWEEN 100000 AND 500000 THEN 'Trung bình'  
            ELSE 'Cao'
        END AS PriceRange
    FROM
        NashVilleHousing
)
SELECT                -- select 4 columns from the temportable
    City, 
    YEAR(SaleDate) AS Year,
    PriceRange,
    COUNT(*) AS NumberOfSales
FROM 
    PriceRangeCTE
GROUP BY      -- group by city first column, then SaleDate the second, then then
    City, 
    YEAR(SaleDate),
    PriceRange
ORDER BY      -- Order by  the arrange of city first, then SaleDate, then then
    City, 
    Year,
    PriceRange;


/*
 Trả lời cho câu hỏi xếp hạng theo tăng dần giá bán trung bình từng năm của giá nhà đươc nhóm theo từng thành phố
*/
WITH PriceRangeCTE AS (              -- Create the first tempor table, get its data, to get data for a new column
    SELECT 
        *,         
        CASE 
            WHEN SalePrice < 100000 THEN 'Thấp'
            WHEN SalePrice BETWEEN 100000 AND 500000 THEN 'Trung bình'
            ELSE 'Cao'
        END AS PriceRange       -- create a column and set its condition to fil data
    FROM 
        NashVilleHousing
),

YearlyAverageCTE AS (              -- create the second tempor table, get all data for this
    SELECT                           
        City,
        YEAR(SaleDate) AS Year,
        AVG(SalePrice) AS YearlyAveragePrice
    FROM PriceRangeCTE                            -- get 3 columns From the privious Tempor table to this table as
    GROUP BY City, YEAR(SaleDate)
)

SELECT      -- select * from the that table, and a new table that 
    *,
    DENSE_RANK() OVER (PARTITION BY City ORDER BY YearlyAveragePrice DESC) AS PriceRank      --get the last column from the previous table based on a condition
FROM YearlyAverageCTE                                    -- pattition by city is pattition by in each group of city, order by desc YAP




/**/
WITH PriceRangeCTE AS (
    SELECT 
        *,
        CASE 
            WHEN SalePrice < 100000 THEN 'Thấp'
            WHEN SalePrice BETWEEN 100000 AND 500000 THEN 'Trung bình'
            ELSE 'Cao'
        END AS PriceRange
    FROM 
        NashVilleHousing
),

YearlyAverageCTE AS (
    SELECT
        City,
        YEAR(SaleDate) AS Year,
        AVG(SalePrice) AS YearlyAveragePrice
    FROM PriceRangeCTE
    GROUP BY City, YEAR(SaleDate)
),

RankedData AS(
SELECT 
    *,
    DENSE_RANK() OVER (PARTITION BY City ORDER BY YearlyAveragePrice DESC) AS PriceRank    
FROM YearlyAverageCTE
)

SELECT * 
FROM RankedData
ORDER BY City, Year
OFFSET 0 ROWS                   -- Split page at the 0th row, this used to devide data set into multiple
FETCH NEXT 20 ROWS ONLY;         -- Split page as its page has 10 rows only
/* Next:
SELECT * 
FROM RankedData
ORDER BY City, Year
OFFSET 10 ROWS                   -- Split page at the 0th row, this used to devide data set into multiple
FETCH NEXT 10 ROWS ONLY;
*/


Select *                              --backspace
From dbo.NashvilleHousing