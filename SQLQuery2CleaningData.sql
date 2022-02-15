-- Cleaning data in SQL Queries 

Select *
From PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------
--1. Standardize Date Format 

-- Before: 2013-04-09 00:00:00.000
-- After:  2013-04-09


Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Alter table Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = Convert(Date,Saledate)

Select SaleDateConverted, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------
--2. Populate Property Address Data

--29 null values

Select propertyaddress
From PortfolioProject.dbo.NashvilleHousing
Where propertyaddress is null

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where propertyaddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null 

Update a
SET PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null 

--(29 rows affected)

----------------------------------------------------------------------------------------------------------------------
--3. Breaking out Address into Individual Columns (Address, City, State) 



Select propertyaddress
From PortfolioProject.dbo.NashvilleHousing
--Where propertyaddress is null


Select
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


Alter table Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

Alter table Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)	
,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)	
From PortfolioProject.dbo.NashvilleHousing

Alter table Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter table Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)	

Alter table Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)	

----------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" Field 

Select Distinct(SoldAsVacant), Count(soldasvacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select Soldasvacant
, Case When SoldAsVacant= 'Y' Then 'Yes'
	When SoldAsVacant= 'N' Then 'No'
	Else SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET soldasvacant = Case When SoldAsVacant= 'Y' Then 'Yes'
	When SoldAsVacant= 'N' Then 'No'
	Else SoldAsVacant
	END 

-------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates 

WITH RowNumCTE As(

Select *, 
	ROW_NUMBER() Over (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice, 
				SaleDate,
				LegalReference
				Order By
					uniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1

--------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns 

Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column Owneraddress, taxDistrict, PropertyAddress, Saledate



--------------------------------------------------------------------------------------------------------------------