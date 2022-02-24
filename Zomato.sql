
-- Case Study using a database provided by Ivy Professional School

-- Zomato is an online restaurant guide and food ordering platform that allows 
-- users to order meals from restaurants and have them delivered.



-- See what we have 
Select top (100) *
From PortfolioProject.dbo.ZomatoData

--1. Ger a distinct list of country codes 

Select Distinct CountryCode
From PortfolioProject.dbo.ZomatoData

--CountryCode
--14
--30
--184
--166
--208
--189
--216
--191
--148
--215
--1
--214
--37
--94
--162

------------------------------------------------------------------------------------

-- 2. Distinct list of country names by Zomato restaurants

Select Distinct Zomatocountrycode.Country, zomatodata.CountryCode
From PortfolioProject.dbo.ZomatoData, PortfolioProject.dbo.Zomatocountrycode
Where ZomatoData.CountryCode = Zomatocountrycode.countrycode

--Country			CountryCode
--india				1
--South Africa		14
--Malasia			30
--Indonesia			37
--Singapure			94
--Hongkong			148
--Nigeria			162
--France			166
--Switzerland		184
--Australia 		189
--New Zealand		191
--Canada 			208
--UAE				214
--UK				215
--USA				216

Select Distinct zomatocountrycode.country
From PortfolioProject.dbo.ZomatoData inner join PortfolioProject.dbo.Zomatocountrycode ON ZomatoData.CountryCode = Zomatocountrycode.countrycode

-----------------------------------------------------------------------------

-- 3. Sumarize total number of countries

Select COUNT(Distinct Zomatocountrycode.Country) as 'Number of countries'
From PortfolioProject.dbo.ZomatoData, PortfolioProject.dbo.Zomatocountrycode
Where ZomatoData.CountryCode = Zomatocountrycode.countrycode

--Number of countries
--15

-----------------------------------------------------------------------------

-- 4. List the combination of country and city and number of restaurants in descending order

Select Distinct Zomatocountrycode.Country, City, COUNT(restaurantID) as 'Number of restaurants'
From PortfolioProject.dbo.ZomatoData, PortfolioProject.dbo.Zomatocountrycode
Where ZomatoData.CountryCode = Zomatocountrycode.countrycode
Group by Zomatocountrycode.Country, City
order by 3 desc

-------------------------------------------------------------------------------

-- 5 List of number of restaurants by country 

Select Zomatocountrycode.Country, COUNT(restaurantID) as 'Number of restaurants'
From PortfolioProject.dbo.ZomatoData, PortfolioProject.dbo.Zomatocountrycode
Where ZomatoData.CountryCode = Zomatocountrycode.countrycode
Group by Zomatocountrycode.Country
order by 2 desc

--Country		Number of restaurants
--india			8652
--USA			434
--UK			80
--UAE			60
--Australia 	60
--Malasia	 	60
--Hongkong		40
--Canada 		34
--South Africa	24
--Nigeria		22
--Singapure		21
--New Zealand	20
--France		20
--Switzerland	20
--Indonesia		4

-------------------------------------------------------------------------------

-- 6. TOP 5 countries with more restaurants 

Select top (5) Zomatocountrycode.Country, COUNT(restaurantID) as 'Number of restaurants'
From PortfolioProject.dbo.ZomatoData, PortfolioProject.dbo.Zomatocountrycode
Where ZomatoData.CountryCode = Zomatocountrycode.countrycode
Group by Zomatocountrycode.Country
order by 2 desc

--Country		Number of restaurants
--india			8652
--USA			434
--UK			80
--Australia 	60
--Malasia		60

---------------------------------------------------------------------------------

-- 7. List the cities with restaurants having Avr. rating of more than 4.5

Select Distinct City, Round(AVG(rating),3)
From PortfolioProject.dbo.ZomatoData
Where Rating > 4.5
Group by City
order by 2 desc

----------------------------------------------------------------------------------

-- 8. Top 2 countries having Avr. rating of more than 4.5

Select top (2) Zomatocountrycode.Country, AVG(rating) as 'AVG. Rating'
From PortfolioProject.dbo.ZomatoData, PortfolioProject.dbo.Zomatocountrycode
Where ZomatoData.CountryCode = Zomatocountrycode.countrycode
and rating > 4.5
Group by Zomatocountrycode.Country
order by 2 desc

--Country		AVG. Rating
--New Zealand	4.9
--Nigeria		4.825

---------------------------------------------------------------------------------
