--cleaning data in sql queries

select *
from [portfolio project on covid done by asmerom kiros]..nashville_housing

--standardize date format

select saledate
from nashville_housing

select saledateconverted,convert(date,saledate)
from [portfolio project on covid done by asmerom kiros]..nashville_housing

----update nashville_housing
----set saledate=convert(date,saledate)

alter table nashville_housing
add saledateconverted date;

update nashville_housing
set saledateconverted=convert(date,saledate)

--populate property adress data

select *
from nashville_housing
----where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.propertyaddress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

----breaking of address into individual columns(address,city,state)

select propertyaddress
from nashville_housing

select propertyaddress,
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as adress,
substring(propertyaddress, charindex(',',propertyaddress)+1,len(propertyaddress)) as city
from nashville_housing
order by city asc

alter table nashville_housing
add propertysplitadress nvarchar(255);

update nashville_housing
set propertysplitadress=substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

alter table nashville_housing
add propertysplitcity nvarchar(255);

update nashville_housing
set propertysplitcity=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select *
from nashville_housing


select owneraddress
from nashville_housing
order by owneraddress desc 

select owneraddress,
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from nashville_housing
order by owneraddress desc

alter table nashville_housing
add ownersplitaddress nvarchar(255);

update nashville_housing
set ownersplitaddress=parsename(replace(owneraddress,',','.'),3)

alter table nashville_housing
add ownersplitcity nvarchar(255);

update nashville_housing
set ownersplitcity=parsename(replace(owneraddress,',','.'),2)

alter table nashville_housing
add ownersplitstate nvarchar(255);

update nashville_housing
set ownersplitstate=parsename(replace(owneraddress,',','.'),1)

select *
from nashville_housing

--change Y and N to yes and no in 'soldasvacant' field

select distinct(soldasvacant),count(soldasvacant)
from nashville_housing
group by soldasvacant
order by 2

select soldasvacant,
case
when soldasvacant = 'y' then 'yes'
when soldasvacant='n' then 'no'
else soldasvacant
end 
from nashville_housing


update nashville_housing
set soldasvacant = case
when soldasvacant = 'y' then 'yes'
when soldasvacant='n' then 'no'
else soldasvacant
end
from nashville_housing


--remove duplicates

select *
from [portfolio project on covid done by asmerom kiros]..nashville_housing

with rownumcte as (
select *,
row_number() over (partition by parcelid,
propertyaddress,saleprice,saledate,legalreference
order by uniqueid) row_num
from nashville_housing)
--order by ParcelID

--delete
--from rownumcte
--where row_num>1
--order by propertyaddress
select *
from rownumcte
where row_num>1


--delete unused columns

select *
from nashville_housing

alter table nashville_housing
drop column saledate