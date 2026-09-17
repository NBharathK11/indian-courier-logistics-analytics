UPDATE dbo.dtdc_logistics_cleaned
SET Delivery_Days = DATEDIFF(DAY, Sender_Date, Receive_Date);

SELECT TOP 10
    Sender_Date,
    Receive_Date,
    Delivery_Days
FROM dbo.dtdc_logistics_cleaned;

SELECT
    Delivery_Days,
    COUNT(*) AS Shipments
FROM dbo.dtdc_logistics_cleaned
GROUP BY Delivery_Days
ORDER BY Delivery_Days;



--SQL ANALYSIS QUERIES
--1. Overall KPIs
SELECT
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value,
    ROUND(AVG(Actual_Wt), 2) AS Avg_Actual_Weight
FROM dbo.dtdc_logistics_cleaned;


--2. Shipment volume by Mode
SELECT
    Mode,
    COUNT(*) AS Shipments,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
    ) AS Shipment_Percentage
FROM dbo.dtdc_logistics_cleaned
GROUP BY Mode
ORDER BY Shipments DESC;


--3. Revenue and delivery performance by Mode
SELECT
    Mode,
    COUNT(*) AS Shipments,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value
FROM dbo.dtdc_logistics_cleaned
GROUP BY Mode
ORDER BY Total_Revenue DESC;


--4. Delivery performance by Consignment Type
SELECT
    Nature_of_Consignment,
    COUNT(*) AS Shipments,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY Nature_of_Consignment
ORDER BY Shipments DESC;


--5. VAS performance
SELECT
    Value_Added_Services,
    COUNT(*) AS Shipments,
    ROUND(AVG(VAS_Charges), 2) AS Avg_VAS_Charge,
    ROUND(SUM(VAS_Charges), 2) AS Total_VAS_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY Value_Added_Services
ORDER BY Total_VAS_Revenue DESC;


--6. Payment method analysis
SELECT
    Mode_of_Payment,
    COUNT(*) AS Shipments,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY Mode_of_Payment
ORDER BY Shipments DESC;


--7. Top 10 Sender Cities
SELECT TOP 10
    Sender_City,
    COUNT(*) AS Shipments,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY Sender_City
ORDER BY Shipments DESC;


--8. Top 10 Origin → Destination routes

-- important logistics analysis.

SELECT TOP 10
    Origin,
    Destination,
    COUNT(*) AS Shipments,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value
FROM dbo.dtdc_logistics_cleaned
GROUP BY Origin, Destination
ORDER BY Shipments DESC;


--9. Delivery-day distribution

--This gives us the 1-day, 2-day, 3-day, 4-day and 5-day distribution
SELECT
    Delivery_Days,
    COUNT(*) AS Shipments,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
    ) AS Shipment_Percentage
FROM dbo.dtdc_logistics_cleaned
GROUP BY Delivery_Days
ORDER BY Delivery_Days;



--10. Weight vs pricing analysis
SELECT
    CASE
        WHEN Actual_Wt < 3 THEN 'Below 3 kg'
        WHEN Actual_Wt < 6 THEN '3 - 6 kg'
        WHEN Actual_Wt < 9 THEN '6 - 9 kg'
        ELSE '9+ kg'
    END AS Weight_Band,
    COUNT(*) AS Shipments,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY
    CASE
        WHEN Actual_Wt < 3 THEN 'Below 3 kg'
        WHEN Actual_Wt < 6 THEN '3 - 6 kg'
        WHEN Actual_Wt < 9 THEN '6 - 9 kg'
        ELSE '9+ kg'
    END
ORDER BY Avg_Shipment_Value;


--11. Monthly shipment and revenue trend

--useful for Power BI.

SELECT
    YEAR(Sender_Date) AS Shipment_Year,
    MONTH(Sender_Date) AS Shipment_Month,
    COUNT(*) AS Shipments,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value
FROM dbo.dtdc_logistics_cleaned
GROUP BY
    YEAR(Sender_Date),
    MONTH(Sender_Date)
ORDER BY
    Shipment_Year,
    Shipment_Month;


--12. Highest-value shipments
SELECT TOP 10
    Pouch_No,
    Origin,
    Destination,
    Mode,
    Actual_Wt,
    Tariff,
    VAS_Charges,
    Total_Amount,
    Delivery_Days
FROM dbo.dtdc_logistics_cleaned
ORDER BY Total_Amount DESC;


--13. City-level revenue
SELECT TOP 10
    Sender_City,
    COUNT(*) AS Shipments,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value
FROM dbo.dtdc_logistics_cleaned
GROUP BY Sender_City
ORDER BY Total_Revenue DESC;


--14. Mode + VAS analysis

-- it combines two business dimensions.

SELECT
    Mode,
    Value_Added_Services,
    COUNT(*) AS Shipments,
    ROUND(AVG(VAS_Charges), 2) AS Avg_VAS_Charge,
    ROUND(SUM(VAS_Charges), 2) AS Total_VAS_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY
    Mode,
    Value_Added_Services
ORDER BY
    Mode,
    Total_VAS_Revenue DESC;

    --15  .Mode + Delivery + Revenue + Weight:

    SELECT
    Mode,
    COUNT(*) AS Shipments,
    ROUND(AVG(Actual_Wt), 2) AS Avg_Weight,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY Mode
ORDER BY Total_Revenue DESC;

--16. Delivery Performance / Delayed Shipments

SELECT
    Mode,
    COUNT(*) AS Total_Shipments,
    SUM(CASE WHEN Delivery_Days > 3 THEN 1 ELSE 0 END) AS Delayed_Shipments,
    ROUND(
        SUM(CASE WHEN Delivery_Days > 3 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2
    ) AS Delay_Percentage
FROM dbo.dtdc_logistics_cleaned
GROUP BY Mode
ORDER BY Delay_Percentage DESC;

--17. Revenue by Month
-- useful for Power BI:

SELECT
    YEAR(Sender_Date) AS Shipment_Year,
    MONTH(Sender_Date) AS Shipment_Month,
    COUNT(*) AS Total_Shipments,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY
    YEAR(Sender_Date),
    MONTH(Sender_Date)
ORDER BY
    Shipment_Year,
    Shipment_Month;

    --18. Weight vs Revenue

SELECT
    CASE
        WHEN Actual_Wt < 3 THEN 'Below 3 kg'
        WHEN Actual_Wt < 6 THEN '3 - 6 kg'
        WHEN Actual_Wt < 9 THEN '6 - 9 kg'
        ELSE '9+ kg'
    END AS Weight_Band,
    COUNT(*) AS Shipments,
    ROUND(AVG(Actual_Wt), 2) AS Avg_Weight,
    ROUND(AVG(Total_Amount), 2) AS Avg_Shipment_Value,
    ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM dbo.dtdc_logistics_cleaned
GROUP BY
    CASE
        WHEN Actual_Wt < 3 THEN 'Below 3 kg'
        WHEN Actual_Wt < 6 THEN '3 - 6 kg'
        WHEN Actual_Wt < 9 THEN '6 - 9 kg'
        ELSE '9+ kg'
    END
ORDER BY Avg_Weight;