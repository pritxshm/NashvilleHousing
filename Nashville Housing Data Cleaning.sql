/* 

Cleaning data in SQL Queries

*/

Select * 
From NashvilleHousing..Nashville
-------------------------------------------------------------------------------------------------------------

--Property Address Data

Select*
From NashvilleHousing..Nashville
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing..Nashville a
Join NashvilleHousing..Nashville b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing..Nashville a
Join NashvilleHousing..Nashville b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------

 -- Split PropertyAddress into Address,City

 Select PropertyAddress,city,Address
From NashvilleHousing..Nashville



 Select PropertyAddress,
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
From NashvilleHousing..Nashville

ALTER TABLE NashvilleHousing..Nashville
Add Address nvarchar(255)

Update NashvilleHousing..Nashville
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing..Nashville
Add City nvarchar(255);

Update NashvilleHousing..Nashville
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


------------------------------------------------------------------------------------------------------


-- Standardize Date Format

Select SaleDateConverted, Convert(Date,SaleDate)
From NashvilleHousing..Nashville

Update NashvilleHousing..Nashville
Set SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing..Nashville
Add SaleDateConverted Date;

Update NashvilleHousing..Nashville
SET SaleDateConverted = Convert(Date,SaleDate)


---------------------------------------------------------------------------------

--Split Owner Address into Address,City,State.

Select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as OwnerCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnerState
From NashvilleHousing..Nashville


ALTER TABLE NashvilleHousing..Nashville
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing..Nashville
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)



ALTER TABLE NashvilleHousing..Nashville
Add OwnerCity nvarchar(255)


Update NashvilleHousing..Nashville
Set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)




ALTER TABLE NashvilleHousing..Nashville
Add OwnerSplitCity nvarchar(255)


Update NashvilleHousing..Nashville
Set OwnersPLITcity = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select OwnerAddress, Ownercity, OwnerSplitcity,OwnerSplitAddress
From NashvilleHousing..Nashville
----------------------------------------------------------------------------------
--Remove Duplicates

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------

-- Change Y,N to Yes,No


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing..Nashville
Group by SoldAsVacant
Order by Count(SoldasVacant)


Select SoldasVacant , Case When SoldAsVacant = 'Y' Then 'Yes'
                           When SoldAsVacant = 'N' Then 'No'
						   ELSE SoldAsVacant
						   End
From NashvilleHousing..Nashville




Update NashvilleHousing..Nashville
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
                           When SoldAsVacant = 'N' Then 'No'
						   ELSE SoldAsVacant
						   End


--------------------------------------------------------------------------
-- Delete Unused Columns

Select *
From NashvilleHousing..Nashville

Alter Table NashvilleHousing..Nashville
Drop Column SaleDate, OwnerAddress, PropertyAddress, TaxDistrict




















