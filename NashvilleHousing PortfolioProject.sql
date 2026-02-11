Select *
From PortfolioProject.dbo.NashvilleHousing

--Standarize Date Format

Select SaleDateConverted, CONVERT(DATE,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

Update NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

-- Property Address Date

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
      AND a.[UniqueID ] <> b.[UniqueID ]
      where a.PropertyAddress is null


      Update a
      Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
      From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
      on a.ParcelID = b.ParcelID
      AND a.[UniqueID ] <> b.[UniqueID ]
      where a.PropertyAddress is null

      --Address Into Individual Columns (Address,City,State)

      Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address 

From PortfolioProject.dbo.NashvilleHousing





ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(225);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
From PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add Ownersplitaddress Nvarchar(225);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(225);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(225);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Sold As Vacant

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
GROUP by SoldAsVacant
order by 2


Select SoldAsVacant
 , CASE when SoldAsVacant = 'Y' Then 'Yes'
      when SoldAsVacant = 'N' Then 'No'
      Else SoldAsVacant
      End
From PortfolioProject.dbo.NashvilleHousing
 

 Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' Then 'Yes'
      when SoldAsVacant = 'N' Then 'No'
      Else SoldAsVacant
      End

      -- Remove Duplicates


      WITH ROWNUMCTE AS(
      Select *,
      Row_NUMBER() OVER (
      PARTITION BY PARCELID,
                  Propertyaddress,
                  SalePrice,
                  SaleDate,
                  LegalReference
                  ORDER BY
                       UNIQUEID
                       ) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
From ROWNUMCTE
where row_num > 1


SELECT *
From PortfolioProject.dbo.NashvilleHousing

-- Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, Propertyaddress 


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate














