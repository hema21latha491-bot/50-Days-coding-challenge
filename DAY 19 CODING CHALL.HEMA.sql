CREATE DATABASE agri_innovate;
USE agri_innovate;

CREATE TABLE farmers (
    farmer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    hire_date DATE
);

CREATE TABLE plots (
    plot_id INT PRIMARY KEY,
    plot_name VARCHAR(100),
    farmer_id INT,
    crop_type VARCHAR(50),
    soil_type VARCHAR(50),
    FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id)
);

CREATE TABLE yields (
    yield_id INT PRIMARY KEY,
    plot_id INT,
    harvest_date DATE,
    yield_kg DECIMAL(10,2),
    weather_condition VARCHAR(50),
    FOREIGN KEY (plot_id) REFERENCES plots(plot_id)
);

CREATE TABLE irrigation_logs (
    log_id INT PRIMARY KEY,
    plot_id INT,
    irrigation_date DATE,
    water_amount_liters DECIMAL(10,2),
    FOREIGN KEY (plot_id) REFERENCES plots(plot_id)
);

INSERT INTO farmers VALUES
(1, 'Ravi', 'Kumar', 'ravi@example.com', '2022-01-10'),
(2, 'Sita', 'Reddy', 'sita@example.com', '2021-03-15'),
(3, 'Arjun', 'Naidu', 'arjun@example.com', '2020-07-20');


INSERT INTO plots VALUES
(101, 'West Field', 1, 'Wheat', 'Loam'),
(102, 'North Pasture', 2, 'Corn', 'Clay'),
(103, 'South Ridge', 3, 'Soybeans', 'Sand'),
(104, 'East Field', 1, 'Wheat', 'Clay');


INSERT INTO yields VALUES
(1, 101, '2025-01-10', 5000, 'Sunny'),
(2, 101, '2025-03-10', 5200, 'Mild'),
(3, 102, '2025-02-15', 4800, 'Rainy'),
(4, 103, '2025-03-20', 4500, 'Sunny'),
(5, 104, '2025-02-25', 4000, 'Rainy'),
(6, 104, '2025-03-30', 4200, 'Mild');

INSERT INTO irrigation_logs VALUES
(1, 101, '2025-01-01', 1500),
(2, 101, '2025-02-01', 1600),
(3, 102, '2025-01-10', 1400),
(4, 103, '2025-02-05', 1300),
(5, 104, '2025-01-15', 1800),
(6, 104, '2025-02-20', 1700);

SELECT * FROM farmers;

SELECT * FROM plots;

SELECT * FROM yields;

SELECT * FROM irrigation_logs;


-- Task 1.1: Top 3 Most Productive Plots

SELECT 
    p.plot_name,
    p.crop_type,
    AVG(y.yield_kg) AS average_yield_kg
FROM plots p
JOIN yields y ON p.plot_id = y.plot_id
GROUP BY p.plot_id, p.plot_name, p.crop_type
ORDER BY average_yield_kg DESC
LIMIT 3;

-- Task 1.2: Total Water Consumption per Plot

SELECT 
    p.plot_name,
    SUM(i.water_amount_liters) AS total_water_liters
FROM plots p
JOIN irrigation_logs i ON p.plot_id = i.plot_id
GROUP BY p.plot_id, p.plot_name
ORDER BY total_water_liters DESC;


-- Task 2.1: Average Yield per Crop & Weather

SELECT 
    p.crop_type,
    y.weather_condition,
    AVG(y.yield_kg) AS average_yield_kg
FROM yields y
JOIN plots p ON y.plot_id = p.plot_id
GROUP BY p.crop_type, y.weather_condition
ORDER BY p.crop_type, y.weather_condition;


-- Task 2.2: Highest Yield per Soil Type


SELECT soil_type, plot_name, highest_yield_kg
FROM (
    SELECT 
        p.soil_type,
        p.plot_name,
        MAX(y.yield_kg) AS highest_yield_kg,
        ROW_NUMBER() OVER (
            PARTITION BY p.soil_type 
            ORDER BY MAX(y.yield_kg) DESC
        ) AS rn
    FROM plots p
    JOIN yields y ON p.plot_id = y.plot_id
    GROUP BY p.soil_type, p.plot_name
) ranked
WHERE rn = 1;


-- Task 3.1: Farmer with Lowest Average Water Usage

SELECT 
    f.first_name,
    f.last_name,
    AVG(i.water_amount_liters) AS average_water_liters_per_plot
FROM farmers f
JOIN plots p ON f.farmer_id = p.farmer_id
JOIN irrigation_logs i ON p.plot_id = i.plot_id
GROUP BY f.farmer_id, f.first_name, f.last_name
ORDER BY average_water_liters_per_plot ASC
LIMIT 1;


-- Task 3.2: Harvest Count per Month (Last 12 Months)

SELECT 
    DATE_FORMAT(harvest_date, '%Y-%m') AS month,
    COUNT(*) AS number_of_harvests
FROM yields
GROUP BY month
ORDER BY month;



-- Task 4: Advanced Analysis (Bonus)


WITH avg_yield AS (
    SELECT 
        p.crop_type,
        AVG(y.yield_kg) AS avg_yield
    FROM plots p
    JOIN yields y ON p.plot_id = y.plot_id
    GROUP BY p.crop_type
),
avg_water AS (
    SELECT 
        p.crop_type,
        AVG(i.water_amount_liters) AS avg_water
    FROM plots p
    JOIN irrigation_logs i ON p.plot_id = i.plot_id
    GROUP BY p.crop_type
)

SELECT 
    p.plot_name,
    p.crop_type,
    y.yield_kg,
    i.water_amount_liters
FROM plots p
JOIN yields y ON p.plot_id = y.plot_id
JOIN irrigation_logs i ON p.plot_id = i.plot_id
JOIN avg_yield ay ON p.crop_type = ay.crop_type
JOIN avg_water aw ON p.crop_type = aw.crop_type
WHERE 
    y.yield_kg < ay.avg_yield
    AND i.water_amount_liters > aw.avg_water;






