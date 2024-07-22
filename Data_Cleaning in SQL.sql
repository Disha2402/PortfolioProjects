/* Cleaning Data in SQL */
select * from SQLTUTORIAL.dbo.NashVilleHousing

------------------------------------------
/* Standardize Sale Date */

select SaleDateConverted from SQLTUTORIAL.dbo.NashVilleHousing

update SQLTUTORIAL.dbo.NashVilleHousing set SaleDate =  Convert(Date , SaleDate);

Alter table  SQLTUTORIAL.dbo.NashVilleHousing add SaleDateConverted

Update  SQLTUTORIAL.dbo.NashVilleHousing set SaleDateConverted = Convert(Date , SaleDate);

----------------------------------------------------------
/* Property Address */
Select a.ParcelId ,a.PropertyAddress , b.ParcelId ,b.PropertyAddress , isnull(a.propertyAddress ,b.propertyAddress)
from SQLTUTORIAL.dbo.NashVilleHousing a
Join SQLTUTORIAL.dbo.NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b. UniqueID
where a.propertyAddress is null;

Update a 
SET PropertyAddress = isnull(a.propertyAddress ,b.propertyAddress)
from SQLTUTORIAL.dbo.NashVilleHousing a
Join SQLTUTORIAL.dbo.NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b. UniqueID
where a.propertyAddress is null;

---------------------------------------------------------
/* Breaking out Address into Separate Columns (Address , City , State) to make the data more usable */
Select  PropertyAddress from SQLTUTORIAL.dbo.NashVilleHousing 
Select 
Substring(PropertyAddress , 1 , Charindex(',' , PropertyAddress)-1) as Address ,
Substring(PropertyAddress , Charindex(',' , PropertyAddress)+1  , len(propertyAddress)) as City
from 
SQLTUTORIAL.dbo.NashVilleHousing ;

Alter table SQLTUTORIAL.dbo.NashVilleHousing add PropertySplitAddress Nvarchar(255);
Alter table SQLTUTORIAL.dbo.NashVilleHousing add PropertySplitCity Nvarchar(255);

Update SQLTUTORIAL.dbo.NashVilleHousing set PropertySplitAddress = Substring(PropertyAddress , 1 , Charindex(',' , PropertyAddress)-1);
Update SQLTUTORIAL.dbo.NashVilleHousing set PropertySplitCity = Substring(PropertyAddress , Charindex(',' , PropertyAddress)+1  , len(propertyAddress)) ;

select OwnerAddress from SQLTUTORIAL.dbo.NashVilleHousing;
select PARSENAME(REPLACE(OwnerAddress,',' ,'.') , 3) as Address , 
PARSENAME(REPLACE(OwnerAddress,',' ,'.') , 2) as City,
PARSENAME(REPLACE(OwnerAddress,',' ,'.') , 1)as State from SQLTUTORIAL.dbo.NashVilleHousing ;

Alter table SQLTUTORIAL.dbo.NashVilleHousing add OwnerSplitAddress Nvarchar(255);
Alter table SQLTUTORIAL.dbo.NashVilleHousing add OwnerSplitCity Nvarchar(255);
Alter table SQLTUTORIAL.dbo.NashVilleHousing add OwnerSplitState Nvarchar(255);

Update SQLTUTORIAL.dbo.NashVilleHousing set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',' ,'.') , 3);

Update SQLTUTORIAL.dbo.NashVilleHousing set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',' ,'.') , 2);

Update SQLTUTORIAL.dbo.NashVilleHousing set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',' ,'.') , 1);

----------------------------------------------------------------------------------------------------

/* Change Y and N to Yes and No in 'SoldasVacant' field */
Select distinct(SoldasVacant) , count(SoldasVacant) 
from SQLTUTORIAL.dbo.NashVilleHousing group by SoldasVacant 
order by 2;


Select SoldasVacant , 
	CASE when SoldasVacant = 'Y' Then 'Yes'
		 when SoldasVacant = ' Yes' Then  'Yes'
		 when SoldasVacant  = 'N' Then 'No'
		 Else SoldasVacant
		 END
from SQLTUTORIAL.dbo.NashVilleHousing

Update SQLTUTORIAL.dbo.NashVilleHousing set SoldAsVacant = 	CASE when SoldasVacant = 'Y' Then 'Yes'
		 when SoldasVacant = ' Yes' Then  'Yes'
		 when SoldasVacant  = 'N' Then 'No'
		 Else SoldasVacant
		 END
----------------------------------------------------------------------------------------------------
/* Remove Duplicates */
WITH RowNumCTE as (
Select * , 
	row_number()  over (
	partition by ParcelID , 
				PropertyAddress,
				SalePrice,
				SaleDateConverted,
				LegalReference
				order by
						uniqueID 
						) row_Num
					from SQLTUTORIAL.dbo.NashVilleHousing )


Delete from RowNumCTE where row_num > 1;

--------------------------------------------------------------------------------------------------
/* Deleting Unused Columns */
ALTER table SQLTUTORIAL.dbo.NashVilleHousing drop column OwnerAddress, TaxDistrict , PropertyAddress

ALTER table SQLTUTORIAL.dbo.NashVilleHousing drop column OwnerAddress, TaxDistrict , PropertyAddress
ALTER table SQLTUTORIAL.dbo.NashVilleHousing drop column SaleDate





