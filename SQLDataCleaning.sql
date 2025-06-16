USE PORTFOLIO
GO

SELECT *
FROM dbo.NashvilleHousing;


--Standardize Date Format
Select SaleDateConverted, CONVERT(Date,SaleDate)
From PORTFOLIO.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

Alter TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

-----------------------------------------------------------------------------

--Populate Property Address Data

Select *
From PORTFOLIO.dbo.NashvilleHousing
--where PropertyAddress is null
Order by ParcelID


Select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PORTFOLIO.dbo.NashvilleHousing a
Join PORTFOLIO.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PORTFOLIO.dbo.NashvilleHousing a
Join PORTFOLIO.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------


--Breaking out Address into individual Columns(Address, City, State)


Select PropertyAddress
From PORTFOLIO.dbo.NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID


Select 
substring(PropertyAddress,1,CHARINDEX(',' , PropertyAddress)-1) as address,
substring(PropertyAddress,CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as address
From PORTFOLIO.dbo.NashvilleHousing



Alter TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',' , PropertyAddress)-1)

Alter TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



Select *
From Portfolio.dbo.NashvilleHousing



Select OwnerAddress
From Portfolio.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolio.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as vacant" field


Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
       Else SoldAsVacant
	   END
From Portfolio.dbo.NashvilleHousing

USE Portfolio;
GO


Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
       Else SoldAsVacant
	   END


--------------------------------------------------------------------------------------
--Remove Duplicates

WITH RowNumCTE as (
Select *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order By 
				    UniqueID
					) row_num

From Portfolio.dbo.NashvilleHousing
--Order By ParcelID
)
--SELECT *
DELETE
From RowNumCTE
Where row_num >1
--Order by PropertyAddress


----------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Portfolio.dbo.NashvilleHousing


ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



















Update NashvilleHousing
Set PropertySplitCity = substring(PropertyAddress,CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PORTFOLIO.dbo.NashvilleHousing


Select OwnerAddress
From PORTFOLIO.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) as a,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) as b,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) as c
From PORTFOLIO.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------

