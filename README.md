# 🏡 Nashville Housing Data Cleaning with SQL

This project focuses on cleaning and preparing a real-world housing dataset using SQL Server. The raw data comes from [Nashville, TN public records](https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data), and the goal is to make it analysis-ready by handling inconsistencies, nulls, column formatting, and duplication.

## 📂 Dataset Used

The dataset used is:  
**`Nashville Housing Data for Data Cleaning.xlsx`**

It contains property sale data with the following features:
- Parcel ID
- Property Address
- Owner Address
- Sale Price and Sale Date
- Legal and Tax references

Each row represents a unique property transaction record.

## 🧹 SQL Data Cleaning Steps

### ✅ 1. Standardize Date Format
Converted `SaleDate` from `datetime` to `date` format for uniformity

### ✅ 2. Populate Missing Property Addresses
Used a self-join on ParcelID to fill NULL values in PropertyAddress

### ✅ 3. Split Address Columns
*PropertyAddress* was split using SUBSTRING and CHARINDEX into:
   - PropertySplitAddress
   - PropertySplitCity

*OwnerAddress* was split using PARSENAME() into:
   - OwnerSplitAddress
   - OwnerSplitCity
   - OwnerSplitState
     
### ✅ 4. Normalize 'SoldAsVacant' Column
Replaced values 'Y' and 'N' with 'Yes' and 'No' using CASE

### ✅ 5. Remove Duplicate Records
Used a ROW_NUMBER() CTE to identify duplicates based on:
   - ParcelID
   - PropertyAddress
   - SalePrice
   - SaleDate
   - LegalReference

Then filtered out rows with row_num > 1.

### ✅ 6. Drop Unnecessary Columns
Dropped columns that were no longer needed:
   - OwnerAddress
   - TaxDistrict
   - Original PropertyAddress (after splitting)

## 🚀 How to Use
Import the Excel file into SQL Server as NashvilleHousing

Open the .sql script in SSMS

Run each block step-by-step to clean the data

Export or analyze the cleaned dataset as needed

## 🧠 Skills Used
SQL Joins & CTEs

Window Functions (ROW_NUMBER)

String Functions (SUBSTRING, PARSENAME, CHARINDEX, REPLACE)

Data Cleaning & Transformation

Null Handling & Categorical Normalization

##📎 Files in this Repository
Nashville_Housing_Cleaning.sql — Full SQL script used for cleaning

Nashville Housing Data for Data Cleaning.xlsx — Original dataset

## 🔗 Credits
Dataset Source: https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data

Project By: Aavash Shrestha





