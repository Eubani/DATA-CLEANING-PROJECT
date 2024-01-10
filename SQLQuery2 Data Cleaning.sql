SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolioproject].[dbo].[NashvilleHousing]


  --Cleaning Data in SQL Queries 

  Select *
  From Portfolioproject.dbo.Nashvillehousing



  --Standardize Data Format

  
  Select SaleDateconverted, CONVERT(Date,SaleDate)
  From Portfolioproject.dbo.Nashvillehousing

  
  Update Nashvillehousing
  SET SaleDate = CONVERT(Date, SaleDate)

  AlTER TABLE Nashvillehousing
  Add SaleDateConverted Date;

  
  Update Nashvillehousing
  SET SaleDateConverted = CONVERT(Date, SaleDate)



  -- Populate Property Address date


  
  Select *
  From Portfolioproject.dbo.Nashvillehousing
  --where PropertyAddress is null
  order by ParcelID


  
  Select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  From Portfolioproject.dbo.Nashvillehousing a
  JOIN Portfolioproject.dbo.Nashvillehousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  From Portfolioproject.dbo.Nashvillehousing a
  JOIN Portfolioproject.dbo.Nashvillehousing b
       on a.ParcelID = b.ParcelID
	   AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Address, City, State)



  Select PropertyAddress
  From Portfolioproject.dbo.Nashvillehousing
  --where PropertyAddress is null
 -- order by ParcelID

 SELECT 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
 from PortfolioProject.dbo.Nashvillehousing


 
  AlTER TABLE Nashvillehousing
  Add PropertySplitAddress Nvarchar(255);

  
  Update Nashvillehousing
  SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )


  
  AlTER TABLE Nashvillehousing
  Add PropertySplitCity Nvarchar(255)

  
  Update Nashvillehousing
  SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) 


  Select *
  from PortfolioProject.dbo.NashvilleHousing


  
  Select OwnerAddress
  from PortfolioProject.dbo.NashvilleHousing


  
  Select 
  PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
 ,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
  from PortfolioProject.dbo.NashvilleHousing



  
 
  AlTER TABLE Nashvillehousing
  Add OwnerSplitAddress Nvarchar(255);

  
  Update Nashvillehousing
  SET OwnerSplitAddress =    PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


  
  AlTER TABLE Nashvillehousing
  Add OwnerSplitCity Nvarchar(255);

  
  Update Nashvillehousing
   SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
  

  
  AlTER TABLE Nashvillehousing
  Add OwnerSplitState Nvarchar(255);

  
  Update Nashvillehousing
   SET OwnerSplitState =   PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
  

 
  
  Select *
  from PortfolioProject.dbo.NashvilleHousing


  --Change Y and N to Yes and No  in 'Sold as Vacant' Field

  Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  from PortfolioProject.dbo.NashvilleHousing
  Group by SoldAsVacant
  order by 2


  
  Select SoldAsVacant
  , Case when SoldAsVacant = 'Y' THEN 'YES'
         When SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END
  from PortfolioProject.dbo.NashvilleHousing

  Update NashvilleHousing
  SET SoldAsVacant =  Case when SoldAsVacant = 'Y' THEN 'YES'
         When SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END
  from PortfolioProject.dbo.NashvilleHousing


  -- Remove Duplicates

  WITH RowNumCTE AS(
  select *,
  ROW_NUMBER() OVER(PARTITION BY ParcelID,
                                 PropertyAddress,
								 SalePrice,
								 SaleDate,
								 LegalReference
								 ORDER BY
								   UniqueID)row_num
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
Where row_num > 1
order by PropertyAddress



---Delete Unused Columns


  Select *
  from PortfolioProject.dbo.NashvilleHousing

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

  
  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  DROP COLUMN SaleDate