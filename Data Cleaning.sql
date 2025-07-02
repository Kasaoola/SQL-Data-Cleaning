-- Cleaning Data in SQL Queries
select * from PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------

-- Standarsize Date Format (SaleDate is originally in datetime format)

select SaleDate
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
alter column SaleDate date

---------------------------------------------------------------------------------------------------

-- Populate Property Address data (generally in the dateset the same ParcelID have the same address)

select * from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join PortfolioProject..NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join PortfolioProject..NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------

-- breaking out address into individual columns (address, city)

select PropertyAddress from PortfolioProject..NashvilleHousing

select substring (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address
	 , substring(PropertyAddress,charindex(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

-- splitting the PropertyAddress to just Address
alter table PortfolioProject..NashvilleHousing
add PropertySplitAddress nvarchar(255)

update PortfolioProject..NashvilleHousing 
set PropertySplitAddress = substring (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


-- splitting the PropertyAddress to just the City
alter table PortfolioProject..NashvilleHousing
add PropertySplitCity nvarchar(255)

update PortfolioProject..NashvilleHousing 
set PropertySplitCity = substring(PropertyAddress,charindex(',', PropertyAddress)+1, Len(PropertyAddress))

select * from PortfolioProject..NashvilleHousing

-- separating OwnerAddress using parsename (easier method)
select parsename(replace(OwnerAddress, ',', '.'), 3),
	parsename(replace(OwnerAddress, ',', '.'), 2),
	parsename(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject..NashvilleHousing

-- splitting the OwnerAddress to just Address
alter table PortfolioProject..NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update PortfolioProject..NashvilleHousing 
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)


-- splitting the OwnerAddress to just the City
alter table PortfolioProject..NashvilleHousing
add OwnerSplitCity nvarchar(255)

update PortfolioProject..NashvilleHousing 
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)

-- splitting the OwnerAddress to just the State
alter table PortfolioProject..NashvilleHousing
add OwnerSplitState nvarchar(255)

update PortfolioProject..NashvilleHousing 
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

select * from PortfolioProject..NashvilleHousing

---------------------------------------------------------------------------------------------------

-- Changing Y and N to Yes and No in 'Sold as Vacant' field

select distinct (SoldAsVacant), count(SoldAsVacant) 
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
	     when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end
from PortfolioProject..NashvilleHousing
where SoldAsVacant = 'N' or SoldAsVacant = 'Y'

update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	     when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end

--------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE as (
select *,
	ROW_NUMBER() over (
	partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by UniqueID
	) as row_num
from PortfolioProject..NashvilleHousing)
--order by ParcelID

select *
--delete
from RowNumCTE
where row_num > 1
order by PropertyAddress

---------------------------------------------------------------------------------------------------

-- Deleting unsued columns

select * from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress
