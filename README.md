# Supply_Chain_Analysis_SQL  
In this project, I will conduct an in-depth analysis from the point of view of a retail business, utilizing a supply chain database. My goal is to construct a detailed business narrative from the perspective of a retailer. This narrative will explore critical operational aspects, including researching on suppliers from whom products are sourced, profiling the customer segments that these products are sold to, and determining the most efficient transportation methods and shipment carriers to bridge the gap between suppliers and customers. The dataset is available in [Kaggle](https://www.kaggle.com/datasets/harshsingh2209/supply-chain-analysis). **The real product name and suppliers name are not available in the dataset. Instead, products are represented by SKU and suppliers are labeled as numbers**

Through a series of structured SQL queries, I will extract and analyze data to answer these key questions:  
- [x] Which suppliers are we purchasing our beauty products from?  
- [x] What are the characteristics of the customers who purchase these products?  
- [x] Which products are more profitable?  
- [x] What transportation methods and shipment carriers are most effective for delivering these products?  


## QUESTION 1 Which Supplier?  
Different suppliers made the most contribution to each of the product types  

Cosmetics: supplier 5  
Haircare: supplier 2  
Skincare: supplier 1  

The contribution sheds light on which supplier is the best at manufacturing which type of product. Therefore, retail stores can make a choice of suppliers based on their contributions.  


## QUESTION 2 Which Customers?
**Overall:**
Producers can generate the highest revenue from the female population overall.  
However, the most important customers for various types of products are different.

### Cosmetics:  
For cosmetics products, the contributions of female, male, and non-binary consumers are about the same.

### Hair Care:   
The arena that hair care product retailers are playing has a lot of male consumers. Therefore, to make more profits, retailers should target male consumers and adjust their business strategies accordingly. For example, when designing advertising campaigns, retailers can emphasize more on the product characteristics that males care about (e.g lower cost). Therefore, the retail business can choose strategy of decreasing production cost and lowering price.

### Skincare:  
Female customers contribute the most to the skincare category. Therefore, to make more profits, retailers should target female consumers and adjust their business strategies accordingly. According to a study by [Tifferet & Herstein (2012)](https://www.emerald.com/insight/content/doi/10.1108/10610421211228793/full/html
), women have a higher level of brand commitment. Hence, the retail business in skincare can choose an strategy of differentiating itself from other brands to increase brand commitment.


## QUESTION 3 Which Products?  
The products recommended for retailers are those products that can bring **high profit, high demand, and high demand/supply synchronization**.

### High Profits  
The products that bring the most total profit are SKU59, SKU81, SKU52 for cosmetics, haircare, and skincare products respectively.

### High Demand and High Demand/Supply Synchronization  
The products that bring the highest demand and Demand/Supply Synchronization are SKU17, SKU43, SKU67 for cosmetics, haircare, and skincare products respectively.  


## QUESTION 4 Which Shipment Route and Carrier?  

### Shipment Route
Look at shipment starting place, transportation mode, and route **individually**:  
The average shipment cost is the lowest when carriers ship the products from Chennai, on route A, and by sea.

Look at the **interaction** of shipment starting place, transportation mode, and route:
The average shipment cost is the lowest when carriers ship the products from Delhi on route B by air.

When considering to decrease the supply chain and shipping cost, the retailer should consider the above way.

### Most Experienced Shipment Carrier
Overall, carrier B managed to ship the most of the time and the highest number of products. It tends to be the most experienced carrier.




