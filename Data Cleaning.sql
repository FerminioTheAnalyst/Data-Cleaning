 ---Cleaning Data in SQL queries


Select *
From PortfolioProject.dbo.NashvilleHousing

---Standardize Date Format
				
SELECT salesdateconverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,Saledate) 


ALTER TABLE NashvilleHousing
Add SalesdateConverted Date;

UPDATE NashvilleHousing
SET SalesDateConverted = CONVERT(Date,Saledate) 


---Populate Property Address data

				
SELECT *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


---Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PROPERTYADDRESS)) as Address 

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) - 1 , LEN(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing
where OwnerAddress is not null

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--- Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End
FROM PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End


---Remove Duplicates
With RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
			     PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing
)
--order by ParcelID
SELECT *
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress


---Delete Unused Columns


Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate    
     