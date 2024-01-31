use supply_chain;

SELECT *
FROM shipment;
SELECT *
FROM sales;

-- What is the average revenue per each product for each customer gender(exclude customers whose gender is unknown)?
SELECT p.customer_gender, ROUND(SUM(s.sales_revenue),2) AS avg_revenue_per_order
FROM Product p
INNER JOIN Sales s 
ON p.SKU = s.SKU
WHERE p.customer_gender <> 'Unknown'
GROUP BY p.customer_gender
ORDER BY avg_revenue_per_order DESC;

SELECT p.product_type, p.customer_gender, ROUND(SUM(s.sales_revenue),2) AS avg_revenue_per_order
FROM Product p
INNER JOIN Sales s 
ON p.SKU = s.SKU
WHERE p.customer_gender <> 'Unknown'
GROUP BY p.product_type, p.customer_gender
ORDER BY p.product_type,avg_revenue_per_order DESC;

-- Which products have been shipped equal to or more than 5 times and have a low average manufacturing defect rate?
WITH ShippedProducts AS (
  SELECT p.SKU, sh.ship_times
  FROM Product p
  JOIN Shipment sh ON p.SKU = sh.ship_SKU
  WHERE sh.ship_times >= 5
)
SELECT p.product_type,p.SKU,SUM(sp.ship_times) ship_times, AVG(m.manu_defect_rates) AS avg_defect_rate
FROM Product p
INNER JOIN Manufacturing m 
USING(sku)
INNER JOIN ShippedProducts sp 
ON p.SKU = sp.SKU
GROUP BY p.product_type,p.SKU
HAVING AVG(m.manu_defect_rates) < 1
ORDER BY p.product_type,ship_times DESC, avg_defect_rate;

-- What is the contribution of each supplier to different product types in terms of total revenue?
SELECT DISTINCT p.product_type, s.supplier_name,
SUM(sa.sales_revenue)OVER(PARTITION BY s.supplier_id,p.product_type) AS total_revenue
FROM Supplier s
JOIN Manufacturing m 
ON s.supplier_id = m.manu_supplier_id
INNER JOIN Product p 
ON m.SKU = p.SKU
INNER JOIN Sales sa 
ON p.SKU = sa.SKU
ORDER BY p.product_type, total_revenue DESC;

-- Identify the most and least profitable product type and products in each product type based on manufacturing costs, shipping costs, and revenue.
WITH ProductProfitability AS (
   SELECT p.product_type,p.SKU,
    SUM(m.manu_costs*number_sold) AS total_manufacturing_cost,
    SUM(sh.ship_cost*number_sold) AS total_shipping_cost,
    SUM(s.sales_revenue) AS total_revenue
  FROM Product p
  JOIN Manufacturing m ON p.SKU = m.SKU
  JOIN Shipment sh ON p.SKU = sh.ship_SKU
  JOIN Sales s ON p.SKU = s.SKU
  GROUP BY p.product_type,p.SKU
)
SELECT
  SKU,
  product_type,
  total_revenue,
  (total_revenue - (total_manufacturing_cost + total_shipping_cost)) AS total_profit,
  NTH_VALUE(SKU,1)
  OVER(PARTITION BY product_type ORDER BY (total_revenue -(total_manufacturing_cost + total_shipping_cost)) DESC)AS MostProfitable,
  NTH_VALUE(SKU,1) 
  OVER(PARTITION BY product_type ORDER BY (total_revenue -(total_manufacturing_cost + total_shipping_cost)) )AS LeastProfitable
FROM ProductProfitability
ORDER BY product_type, total_profit DESC;

-- Identify products with low availability and long inventory replenishment lead time and the rank among them.
SELECT
	p.SKU,
    p.product_type,
    p.availability,
    i.inve_lead_times
FROM Product p
JOIN Inventory i ON p.SKU = i.SKU
WHERE p.availability < 20 AND i.inve_lead_times > 20;
  
WITH ProductInventoryStats AS (
 SELECT
	p.SKU,
    p.product_type,
    p.availability,
    i.inve_lead_times
  FROM Product p
  JOIN Inventory i ON p.SKU = i.SKU
  WHERE p.availability < 20 AND i.inve_lead_times > 20
)
SELECT
  SKU,
  product_type,
  RANK() OVER (ORDER BY availability) AvailabilityRank,
  RANK() OVER (ORDER BY inve_lead_times DESC) LeadTimeRank
FROM ProductInventoryStats
ORDER BY AvailabilityRank,LeadTimeRank;

-- Find the top 3 sku in each product type with highest demand (highest number sold), lowest manufacturing lead time and the lowest shipping cost, sorted by sku name.
WITH psm AS(
SELECT product_type, p.SKU,p.number_sold,sm.ship_cost, sm.Manu_lead_time
	FROM product p
	INNER JOIN (
		SELECT *
		FROM shipment s
		INNER JOIN manufacturing m
		ON s.ship_SKU = m.SKU) sm
	ON p.SKU = sm.SKU)
,rankings AS (
	SELECT product_type, SKU,
	DENSE_RANK()OVER(ORDER BY number_sold) AS NumSoldRank,
	DENSE_RANK()OVER(ORDER BY ship_cost) AS ShipCostRank,
	DENSE_RANK()OVER(ORDER BY manu_lead_time) AS MaLeadTimeRank
	FROM psm
	ORDER BY NumSoldRank, ShipCostRank,MaLeadTimeRank)
SELECT product_type,SKU,AVG(NumSoldRank+ShipCostRank+MaLeadTimeRank) AS AvgRanking
FROM rankings
GROUP BY product_type,SKU
ORDER BY AvgRanking
LIMIT 3;

-- Find the average shipping cost by location, shipping method, and shipping routes, sorted by shipping cost.
SELECT 'ByLocation' AS GroupType,
	m.manu_location AS GroupKey,
    AVG(ship_cost) AvgCost
FROM shipment s
RIGHT JOIN manufacturing m
ON s.ship_SKU = m.SKU
GROUP BY m.manu_location
UNION ALL
	SELECT 'ByMethod' AS GroupType,
		ship_method AS GroupKey,
        AVG(ship_cost) AvgCost
	FROM shipment 
	GROUP BY ship_method
UNION ALL
	SELECT 'ByRoute' AS GroupType,
		ship_route AS GroupKey,AVG(ship_cost) AvgCost
	FROM shipment 
	GROUP BY ship_route
	ORDER BY 
		GroupType,
		AvgCost;

-- Find combination of location, route, and transportation mode with the lowest shipping cost
SELECT m.manu_location AS Location, 
	s.ship_method AS Transportation_mode,
    s.ship_route AS Route,
    AVG(ship_cost) AS Ship_cost
FROM manufacturing m
LEFT JOIN shipment s
ON s.ship_SKU = m.SKU
GROUP BY m.manu_location,s.ship_method,s.ship_route
ORDER BY Ship_cost
LIMIT 1;



-- Find the overall shipping times and number of SKU shipped by each shipping carrier, sorted by shipping time.
SELECT ship_carrier_name,
	SUM(s.ship_times) AS SumShipTime,
    COUNT(s.ship_SKU) AS NumSkuShipped
FROM shipment s
INNER JOIN ship_carrier sc
USING(ship_carrier_id)
GROUP BY ship_carrier_name
ORDER BY SumShipTime DESC;
